---
name: commit-push
description: >
  Stage, commit, and push changes to the remote repository. Analyzes the current
  diff, generates a commit message, confirms it with the user before committing,
  then pushes. Use this skill whenever the user says "commit and push", "commit-push",
  "ship it", "push my changes", or invokes /commit-push.
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [git, commit, push, conventional-commits]
allowed-tools: Bash(git *), Bash(gh *), AskUserQuestion
---

# Commit and Push

## Overview

This skill handles the full commit-and-push workflow: stage changes, generate a meaningful commit message, get user approval on the message, commit, and push to the remote.

## Workflow

### Step 1: Assess the Current State

Run these commands in parallel to understand what needs to be committed:

1. `git status` — see staged, unstaged, and untracked files (never use `-uall`)
2. `git diff` — see unstaged changes
3. `git diff --cached` — see already-staged changes
4. `git log --oneline -5` — see recent commit style for message consistency
5. `git branch --show-current` — identify the current branch

If there are no changes (nothing staged, no modifications, no untracked files), inform the user and stop.

### Step 2: Stage Changes

- Stage all modified and new files relevant to the current work using `git add` with specific file paths.
- Do NOT stage files that look like secrets or credentials (`.env`, `credentials.json`, `*.key`, `*.pem`). If such files appear, warn the user and skip them.
- Do NOT use `git add -A` or `git add .` — always add specific files by name.

### Step 3: Generate a Commit Message

Analyze the staged diff (`git diff --cached`) and draft a commit message following the **Conventional Commits** specification (https://www.conventionalcommits.org/en/v1.0.0/).

#### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types

Choose the correct type based on the nature of the change:

| Type       | When to use                                      |
|------------|--------------------------------------------------|
| `feat`     | A new feature (correlates with SemVer MINOR)     |
| `fix`      | A bug fix (correlates with SemVer PATCH)         |
| `docs`     | Documentation-only changes                       |
| `style`    | Formatting, whitespace, semicolons — no logic change |
| `refactor` | Code restructuring without fixing a bug or adding a feature |
| `perf`     | Performance improvement                          |
| `test`     | Adding or updating tests                         |
| `build`    | Build system or external dependency changes      |
| `ci`       | CI configuration changes                         |
| `chore`    | Maintenance tasks that don't modify src or tests |

#### Breaking Changes

If the change introduces a breaking change, indicate it with:
- An exclamation mark after the type/scope, e.g. **feat!: remove deprecated login endpoint**
- And/or a **BREAKING CHANGE:** footer explaining what broke and why

#### Rules

- **Description** (after the colon): required, lowercase, imperative mood, no period at the end, under 72 characters.
- **Scope** (in parentheses): optional, identifies the area of the codebase (e.g., `feat(api):`, `fix(auth):`).
- **Body**: optional, separated from the description by a blank line. Explain **why** the change was made and any important context.
- **Footers**: optional, follow git trailer format (`token: value`). Use `-` instead of spaces in multi-word tokens (e.g., `Reviewed-By:`).

#### Examples

```
feat(api): add search endpoint for notes

Supports full-text search across note title and content.
Returns results sorted by relevance.
```

```
fix(db): prevent duplicate IDs on concurrent inserts
```

```
refactor: extract database queries into separate module
```

```
feat!: change API response format to envelope pattern

BREAKING CHANGE: all API responses now wrapped in { data, meta } envelope.
Clients using the flat response format must update their parsers.
```

```
docs: update README with new build instructions
```

#### Additional Guidelines

- Also check the style of recent commits in the repo (from Step 1) for any project-specific conventions on scope names or patterns.
- If the change spans multiple concerns, use the body for bullet points.
- Append the co-author trailer as the final footer:
  ```
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

### Step 4: Confirm the Commit Message with the User

**This step is mandatory.** Use the `AskUserQuestion` tool to present the proposed commit message and ask the user to approve or edit it.

Present it like this:
- Show the proposed commit message clearly.
- Offer options: "Use this message", "Edit message" (where the user can type their own), or other options if relevant.

Do NOT proceed to commit without explicit user approval of the message.

### Step 5: Commit

Once the user approves (or provides an edited message):

- Create the commit using the approved message via a HEREDOC:
  ```bash
  git commit -m "$(cat <<'EOF'
  <approved message here>

  Co-Authored-By: Claude <noreply@anthropic.com>
  EOF
  )"
  ```
- If the user edited the message, use their version (still append the co-author trailer if they didn't include it).
- If a pre-commit hook fails, report the error to the user. Do NOT use `--no-verify`. Fix the issue if possible, re-stage, and create a NEW commit (never amend).

### Step 6: Push

After a successful commit:

1. Check if the current branch has an upstream tracking branch: `git rev-parse --abbrev-ref @{upstream}`
2. If no upstream exists, push with: `git push -u origin <branch-name>`
3. If upstream exists, push with: `git push`
4. Report the result to the user — include the branch name and remote.

If the push fails (e.g., rejected due to remote changes), inform the user and suggest next steps (pull + rebase, force push, etc.). Do NOT force-push without explicit user approval.

### Step 7: Summary

After a successful push, give a brief summary:
- Branch name
- Commit hash (short)
- Commit message subject line
- Remote pushed to
