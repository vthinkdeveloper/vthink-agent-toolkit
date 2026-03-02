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
| _(none yet)_ | | | |

### devops

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

---

## Skills

Workflow and domain knowledge prompts. Place files in `skills/<category>/`.

### frontend

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### backend

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

### data

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

---

## Slash Commands

Invocable via `/command-name` in Claude Code. Place files in `.claude/commands/`.

| Name | Invocation | File | Description | Author |
|------|-----------|------|-------------|--------|
| _(none yet)_ | | | | |

---

## Hooks

Shell scripts triggered by Claude Code tool events. Place in `hooks/pre-tool/` or `hooks/post-tool/`.

### pre-tool

| Name | File | Trigger | Description | Author |
|------|------|---------|-------------|--------|
| _(none yet)_ | | | | |

### post-tool

| Name | File | Trigger | Description | Author |
|------|------|---------|-------------|--------|
| _(none yet)_ | | | | |

---

## Rules

CLAUDE.md snippets for always-follow instructions. Place files in `rules/`.

| Name | File | Description | Author |
|------|------|-------------|--------|
| _(none yet)_ | | | |

---

## How to Update This File

When you open a PR with a new contribution, add a row to the relevant table above:

- **Name** — the `name` field from your frontmatter
- **File** — relative path from repo root (e.g., `skills/backend/my-skill.md`)
- **Description** — the `description` field from your frontmatter
- **Author** — your GitHub username

Reviewers will check that this file is updated as part of the PR review.
