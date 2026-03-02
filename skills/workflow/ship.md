---
name: ship
description: >
  Ship your staged changes: runs a conventions check on staged files, generates
  a commit message with ticket ID from branch name, commits, and pushes. Use this
  instead of manual git commit + push. Invoke with `/ship` or when the user says
  "ship it", "commit and push", or "send it".
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [git, commit, push, conventions, quality-gate]
argument-hint: "[optional commit message override]"
allowed-tools: Bash(git *), Bash(gh *), Read, Grep, Glob
---

# Ship — Conventions Check + Commit + Push

## Overview

This skill is your pre-commit quality gate + shipping workflow. It checks staged files against project conventions, generates a good commit message, commits, and pushes — all in one step.

## Workflow

### Step 1: Pre-flight Checks

1. Run `git status` to see the current state
2. Run `git diff --cached --name-only` to get the list of staged files
3. If **no staged files**:
   - Run `git diff --name-only` to check for unstaged changes
   - If unstaged changes exist, show them and ask the user which files to stage using AskUserQuestion
   - If no changes at all, tell the user "Nothing to ship — working tree is clean" and stop
4. Run `git rev-parse --abbrev-ref HEAD` to get the current branch name
5. Display the staged files to the user

### Step 2: Conventions Check on Staged Files

Run a conventions check on the staged files only. This is a lightweight version focused on the files being committed.

**2a. Discover project conventions:**

Read these sources (skip any that don't exist):
1. `CLAUDE.md` in the project root — explicit architecture, patterns, coding conventions
2. Linter/formatter configs — `.eslintrc*`, `.prettierrc*`, `checkstyle.xml`, `.editorconfig`, `pom.xml`
3. For each staged file, read 1-2 existing files of the same type in the same directory to identify local patterns

**2b. Analyze staged files:**

For each staged file:
1. Read the file's full contents
2. Run `git diff --cached -- <file>` to see what specifically changed
3. Check the **changed lines** against applicable conventions
4. Focus on the diff — don't flag pre-existing issues in unchanged lines

**2c. Report findings:**

Present a concise report:

```
## Pre-commit Conventions Check

**Files:** <count> staged files checked
**Result:** <error-count> errors, <warning-count> warnings, <info-count> info

### Findings (if any)

| File | Severity | Rule | Line(s) | Finding | Fix |
|------|----------|------|---------|---------|-----|
| ... | Error | ... | ... | ... | ... |
```

### Step 3: Gate Decision

- **If errors found:** Stop. Show the report and tell the user "Fix the errors above before shipping. Run `/ship` again when ready."
- **If only warnings/info:** Show the report, then proceed to commit (warnings don't block)
- **If clean:** Say "Conventions check passed" and proceed

### Step 4: Generate Commit Message

**4a. Extract ticket ID from branch name:**

Parse the branch name for a ticket ID pattern like `PROJ-1234` or `FEAT-567`:
- Pattern: `[A-Z]+-\d+` (e.g., `FEAT-1702` from `FEAT-1702-bootstrap-migration`)
- If no ticket ID found, skip the prefix

**4b. Analyze changes for message:**

1. Run `git diff --cached` to see the full staged diff
2. Run `git log --oneline -5` to see recent commit message style

**4c. Draft the commit message:**

- If `$ARGUMENTS` was provided, use that as the commit message (still prepend ticket ID)
- Otherwise, generate a message that:
  - Starts with the ticket ID followed by colon and space (e.g., `FEAT-1702: `)
  - Summarizes the "why" not the "what"
  - Is concise (1-2 sentences)
  - Matches the style of recent commits in the repo
  - Ends with `Co-Authored-By: Claude <noreply@anthropic.com>`

**4d. Show the commit message to the user** and ask for approval using AskUserQuestion with options:
- "Commit with this message" (proceed)
- "Edit message" (let user provide their own)

### Step 5: Commit

Run the commit using heredoc format:

```bash
git commit -m "$(cat <<'EOF'
TICKET-ID: Summary message here.

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 6: Push

1. Check if the branch has an upstream: `git rev-parse --abbrev-ref @{upstream} 2>/dev/null`
2. If no upstream, push with `-u`: `git push -u origin <branch-name>`
3. If upstream exists, push: `git push`
4. Show the result to the user

### Step 7: Summary

Display a final summary:
```
Shipped!
- Branch: <branch>
- Commit: <short-hash> <message>
- Pushed to: origin/<branch>
```

## Important Rules

- **Never force push.** If push fails due to diverged history, stop and tell the user.
- **Never amend.** Always create new commits.
- **Never skip hooks.** Don't use `--no-verify`.
- **Don't stage files automatically** unless the user explicitly approves which files to stage.
- **Respect .gitignore.** Don't suggest staging ignored files.
- If the user provided `$ARGUMENTS` as a commit message, still run the conventions check — the message override only skips message generation, not the quality gate.
