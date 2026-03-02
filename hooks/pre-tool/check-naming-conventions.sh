#!/usr/bin/env bash
# check-naming-conventions.sh
#
# PreToolUse hook — runs before Write or Edit tool calls.
# Checks that the target file path follows naming conventions for its file type.
#
# Usage in .claude/settings.json:
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "Write|Edit",
#       "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/check-naming-conventions.sh" }]
#     }]
#   }
#
# Override defaults by creating .claude/naming-conventions.json in your project.
# Exit 0 = allow, Exit 1 = block with message shown to Claude.

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from the tool input JSON
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', tool_input.get('path', '')))
" 2>/dev/null || echo "")

# Nothing to check if no file path
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILENAME=$(basename "$FILE_PATH")
EXTENSION="${FILENAME##*.}"
NAME_WITHOUT_EXT="${FILENAME%.*}"

# ── Load project overrides if present ────────────────────────────────────────
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CONVENTIONS_FILE="$PROJECT_DIR/.claude/naming-conventions.json"

# Default: warn only (don't hard-block). Set to "block" in conventions file to enforce.
MODE="warn"

if [[ -f "$CONVENTIONS_FILE" ]]; then
  MODE=$(python3 -c "
import json, sys
with open('$CONVENTIONS_FILE') as f:
    c = json.load(f)
print(c.get('mode', 'warn'))
" 2>/dev/null || echo "warn")
fi

# ── Convention rules by file type ────────────────────────────────────────────
VIOLATIONS=()

check_kebab_case() {
  local name="$1"
  # Allow: lowercase letters, numbers, hyphens. No underscores, no spaces, no camelCase.
  if [[ ! "$name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    VIOLATIONS+=("'$name' should be kebab-case (e.g., my-component, user-service)")
  fi
}

check_snake_case() {
  local name="$1"
  if [[ ! "$name" =~ ^[a-z][a-z0-9_]*$ ]]; then
    VIOLATIONS+=("'$name' should be snake_case (e.g., my_module, user_service)")
  fi
}

check_pascal_case() {
  local name="$1"
  if [[ ! "$name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    VIOLATIONS+=("'$name' should be PascalCase (e.g., MyClass, UserService)")
  fi
}

check_no_spaces() {
  if [[ "$FILENAME" == *" "* ]]; then
    VIOLATIONS+=("Filename contains spaces — use hyphens or underscores instead")
  fi
}

# Always check for spaces
check_no_spaces

# Apply rules based on extension
case "$EXTENSION" in
  js|jsx|ts|tsx)
    # React components: PascalCase. Everything else: kebab-case or camelCase.
    # Heuristic: if it's in a components/ directory, expect PascalCase.
    if [[ "$FILE_PATH" == */components/* || "$FILE_PATH" == */pages/* || "$FILE_PATH" == */views/* ]]; then
      check_pascal_case "$NAME_WITHOUT_EXT"
    else
      check_kebab_case "$NAME_WITHOUT_EXT"
    fi
    ;;
  py)
    check_snake_case "$NAME_WITHOUT_EXT"
    ;;
  java|kt)
    check_pascal_case "$NAME_WITHOUT_EXT"
    ;;
  sh|bash)
    check_kebab_case "$NAME_WITHOUT_EXT"
    ;;
  md)
    check_kebab_case "$NAME_WITHOUT_EXT"
    ;;
  # No opinion on other extensions (css, json, yaml, etc.)
esac

# ── Output results ────────────────────────────────────────────────────────────
if [[ ${#VIOLATIONS[@]} -eq 0 ]]; then
  exit 0
fi

echo "Naming convention check:"
for v in "${VIOLATIONS[@]}"; do
  echo "  ⚠  $v"
done
echo ""
echo "File: $FILE_PATH"

if [[ "$MODE" == "block" ]]; then
  echo ""
  echo "Rename the file to match conventions before proceeding."
  echo "(To change enforcement mode, edit .claude/naming-conventions.json)"
  exit 1
else
  # Warn mode: print message but allow Claude to proceed
  echo ""
  echo "Note: Continuing anyway (mode=warn). Set mode=block in .claude/naming-conventions.json to enforce."
  exit 0
fi
