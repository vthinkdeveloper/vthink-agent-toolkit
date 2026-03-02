# CLAUDE.md — vthink-claudecode-toolkit

This file provides Claude Code with context about this repository's structure and purpose.

## What This Repo Is

`vthink-claudecode-toolkit` is a curated collection of Claude Code customizations for the vthink engineering team. It contains:

- **Agents** — sub-agent definitions with specific roles and responsibilities
- **Skills** — workflow and domain knowledge prompts
- **Slash Commands** — `.md` files in `.claude/commands/` invocable as `/command-name`
- **Hooks** — shell scripts triggered by Claude Code tool events
- **Rules** — CLAUDE.md snippets that can be copy-pasted into project-level CLAUDE.md files

## Directory Structure

```
.claude/commands/       # Slash commands
agents/                 # Sub-agents by category (core-development, code-review, testing, devops)
skills/                 # Skills by category (frontend, backend, data)
hooks/pre-tool/         # PreToolUse hook scripts
hooks/post-tool/        # PostToolUse hook scripts
rules/                  # CLAUDE.md snippet files
templates/              # Starter templates (agent-template.md, skill-template.md, command-template.md)
examples/               # Usage examples
docs/                   # Documentation
.github/                # PR and issue templates
```

## When Helping Contributors

If someone asks you to help create a new skill, agent, or command in this repo:

1. Point them to the relevant template in `templates/`
2. Confirm the correct category folder for placement
3. Ensure all frontmatter fields are filled in: `name`, `description`, `version`, `author`, `category`, `tags`
4. Check that no project-specific or sensitive information is included
5. File naming must be kebab-case

## Frontmatter Schema

All skill/agent/command `.md` files must begin with:

```yaml
---
name: kebab-case-name
description: One-line description
version: 1.0.0
author: github-username
category: <category>
tags: [tag1, tag2]
---
```

## Contribution Standards

See `CONTRIBUTING.md` for the full guide. Key points:
- No company-specific project names, internal URLs, or credentials
- Generic enough to work across different projects
- Project-specific config should be read from local files (e.g., `DEVAPP.json`, `package.json`)
