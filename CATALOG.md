# Toolkit Catalog

This file is the **single source of truth** for everything in the toolkit. When you add a new skill, agent, command, or hook, **update this file as part of your PR**.

> Keep entries sorted alphabetically within each section.

---

## Agents

Sub-agents with defined roles and responsibilities. Place files in `agents/<category>/`.

### core-development

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### code-review

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### testing

| Name | File | Description | Author |
|------|------|-------------|--------|
| test-runner | [`agents/testing/test-runner.md`](agents/testing/test-runner.md) | Run the project's test suite, auto-fix failures, and verify all tests pass. Auto-detects test command from project config. | adharsh2208vthink |

### devops

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

---

## Skills

Workflow and domain knowledge prompts. Place files in `skills/<category>/`.

### backend

| Name | File | Description | Author |
|------|------|-------------|--------|
| generate-endpoint | [`skills/backend/generate-endpoint.md`](skills/backend/generate-endpoint.md) | Generate a complete CRUD endpoint for a new resource. Auto-detects project structure and adapts to existing conventions. | adharsh2208vthink |

### data

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### frontend

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### workflow

| Name | File | Description | Author |
|------|------|-------------|--------|
| anonymize-prompt | [`skills/workflow/anonymize-prompt.md`](skills/workflow/anonymize-prompt.md) | Generate a privacy-safe, anonymized prompt for pasting into external search engines and AI chatbots without leaking proprietary details. | adharsh2208vthink |
| bdd-gherkin | [`skills/workflow/bdd-gherkin.md`](skills/workflow/bdd-gherkin.md) | Generate BDD Gherkin feature files from requirements — even vague ones — through a collaborative clarifying conversation. | adharsh2208vthink |
| commit-push | [`skills/workflow/commit-push.md`](skills/workflow/commit-push.md) | Stage, generate a Conventional Commits message, get user approval, commit, and push in one workflow. | adharsh2208vthink |
| conventions-check | [`skills/workflow/conventions-check.md`](skills/workflow/conventions-check.md) | Check code changes against project conventions discovered from the codebase itself. Supports PR number or file path mode. | adharsh2208vthink |
| give-me-a-commit-message | [`skills/workflow/give-me-a-commit-message.md`](skills/workflow/give-me-a-commit-message.md) | Suggest a commit message from current changes. Extracts ticket ID from branch name. Does NOT commit. | adharsh2208vthink |
| qa-guide | [`skills/workflow/qa-guide.md`](skills/workflow/qa-guide.md) | Generate a comprehensive QA testing guide for a GitHub PR, written for non-technical testers. | adharsh2208vthink |
| ship | [`skills/workflow/ship.md`](skills/workflow/ship.md) | Quality gate + commit + push in one step. Runs conventions check, generates commit message with ticket ID, and pushes. | adharsh2208vthink |

---

## Slash Commands

Invocable via `/command-name` in Claude Code. Place files in `.claude/commands/`.

| Name | Invocation | File | Description | Author |
|------|-----------|------|-------------|--------|
| dev-server | `/dev-server <start\|stop\|restart>` | [`.claude/commands/dev-server.md`](.claude/commands/dev-server.md) | Manage the local dev server. Auto-detects start command and port from package.json. | adharsh2208vthink |

---

## Hooks

Shell scripts triggered by Claude Code tool events. Place in `hooks/pre-tool/` or `hooks/post-tool/`.

### pre-tool

| Name | File | Trigger | Description | Author |
|------|------|---------|-------------|--------|
| check-naming-conventions | [`hooks/pre-tool/check-naming-conventions.sh`](hooks/pre-tool/check-naming-conventions.sh) | Write, Edit | Checks file naming conventions before Claude writes or edits a file. Enforces kebab-case (JS/TS), snake_case (Python), PascalCase (Java/components). Configurable via `.claude/naming-conventions.json`. | adharsh2208vthink |

### post-tool

| Name | File | Trigger | Description | Author |
|------|------|---------|-------------|--------|
| _(none yet)_ | | | | |

---

## Rules

CLAUDE.md snippets for always-follow instructions. Place files in `rules/`.

| Name | File | Description | Author |
|------|------|-------------|--------|
| file-organization | [`rules/file-organization.md`](rules/file-organization.md) | Instructs Claude to save plan/doc files to `docs/` and follow existing directory structure for new source files. | adharsh2208vthink |
| planning-collaboration | [`rules/planning-collaboration.md`](rules/planning-collaboration.md) | Controls Claude's behaviour in Plan Mode — wait for user approval, share only meaningful findings, avoid auto-proceeding. | adharsh2208vthink |

---

## How to Update This File

When you open a PR with a new contribution, add a row to the relevant table above:

- **Name** — the `name` field from your frontmatter
- **File** — relative path from repo root (e.g., `skills/backend/my-skill.md`)
- **Description** — the `description` field from your frontmatter
- **Author** — your GitHub username

Reviewers will check that this file is updated as part of the PR review.
