---
name: commit-push-pr
description: >
  Stage, commit, push, and open a pull request in one workflow. Confirms the
  commit message, PR title, and PR description with the user before acting.
  Use this skill whenever the user says "commit push and PR", "commit and open a PR",
  "push and raise a PR", or invokes /commit-push-pr.
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [git, commit, push, pull-request, gh, conventional-commits]
allowed-tools: Bash(git *), Bash(gh *), AskUserQuestion
---

# Commit, Push, and Open a PR

## Overview

This skill handles the full commit → push → PR workflow. It confirms the commit message, PR title, and PR description with the user before doing anything irreversible.

---

## Workflow

### Step 1: Assess the Current State

Run these commands in parallel:

1. `git status` — see staged, unstaged, and untracked files (never use `-uall`)
2. `git diff` — see unstaged changes
3. `git diff --cached` — see already-staged changes
4. `git log --oneline -5` — see recent commit style for message consistency
5. `git branch --show-current` — identify the current branch
6. `git remote get-url origin` — identify the remote

If there are no changes, inform the user and stop.

Check that `gh` is authenticated: run `gh auth status`. If not authenticated, tell the user to run `gh auth login` and stop.

---

### Step 2: Stage Changes

- Stage all modified and relevant files using `git add` with specific file paths.
- Do NOT stage secrets or credentials (`.env`, `credentials.json`, `*.key`, `*.pem`). Warn the user and skip them.
- Do NOT use `git add -A` or `git add .`.

---

### Step 3: Generate a Commit Message

Analyze `git diff --cached` and draft a commit message following **Conventional Commits** (https://www.conventionalcommits.org/en/v1.0.0/).

#### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types

| Type | When to use |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `style` | Formatting, whitespace — no logic change |
| `refactor` | Code restructuring, no feature or fix |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `build` | Build system or dependency changes |
| `ci` | CI configuration changes |
| `chore` | Maintenance, no src/test changes |

#### Rules

- Description: lowercase, imperative mood, no period, under 72 characters
- Body: explain *why*, not what — separated by a blank line
- For breaking changes: add `!` after type/scope and a `BREAKING CHANGE:` footer
- Always append as the final footer:
  ```
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

---

### Step 4: Confirm the Commit Message

**Mandatory.** Use `AskUserQuestion` to show the proposed message and get approval.

Options: "Use this message" / "Edit message" (user types their own).

Do NOT commit without explicit approval.

---

### Step 5: Commit

```bash
git commit -m "$(cat <<'EOF'
<approved message>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

If a pre-commit hook fails: report the error, do NOT use `--no-verify`, fix and create a NEW commit (never amend).

---

### Step 6: Push

1. Check upstream: `git rev-parse --abbrev-ref @{upstream}`
2. No upstream → `git push -u origin <branch-name>`
3. Upstream exists → `git push`

If the push is rejected, inform the user and suggest next steps. Do NOT force-push without explicit approval.

---

### Step 7: Determine the Base Branch

Run:
```bash
gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
```

Also check if a `develop` branch exists:
```bash
git branch -r | grep -E 'origin/(develop|main|master)'
```

Use this priority to pick the base branch:
1. `develop` — if it exists on the remote
2. `main` — if it exists
3. `master` — fallback
4. Ask the user if none of the above are found

---

### Step 8: Generate PR Title and Description

Derive the PR title from the commit message subject line (the first line).

For the description, analyze the full diff (`git log <base>..<current-branch> --oneline` and `git diff <base>..HEAD`) and generate:

```markdown
## Summary

- [bullet points describing what changed and why]

## Test plan

- [ ] [specific things a reviewer should verify, based on the actual changes]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

Tailor the test plan to the actual changes — don't use generic placeholders.

---

### Step 9: Confirm PR Title and Description with the User

**Mandatory.** Show the proposed PR title and description and ask for approval before creating the PR.

Use `AskUserQuestion`:

> "Here's the PR I'll open against `[base branch]`:
>
> **Title:** [proposed title]
>
> **Description:**
> [proposed description]
>
> Does this look good?"

Options:
- **Looks good, create the PR** — proceed
- **Edit the title** — ask the user to type a new title, then re-confirm
- **Edit the description** — ask the user to type or paste a new description, then re-confirm
- **Cancel** — stop without creating the PR

Do NOT create the PR without explicit user approval.

---

### Step 10: Create the PR

```bash
gh pr create \
  --base <base-branch> \
  --title "<approved title>" \
  --body "<approved description>"
```

Use a HEREDOC for the body to preserve formatting:

```bash
gh pr create --base <base-branch> --title "<approved title>" --body "$(cat <<'EOF'
<approved description>
EOF
)"
```

---

### Step 11: Summary

After a successful PR creation, report:

```
✅ Done!

Commit:  <short hash> — <commit subject>
Branch:  <branch> → <base-branch>
PR:      <PR URL>
```
