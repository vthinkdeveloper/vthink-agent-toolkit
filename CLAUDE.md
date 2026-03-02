# CLAUDE.md — vthink-claudecode-toolkit

This file provides Claude Code with context about this repository's structure and purpose.

## What This Repo Is

`vthink-claudecode-toolkit` is a curated collection of Claude Code customizations for the vthink engineering team. It contains:

- **Agents** — sub-agent definitions with specific roles and responsibilities
- **Skills** — workflow and domain knowledge prompts
- **Slash Commands** — `.md` files in `.claude/commands/` invocable as `/command-name`
- **Hooks** — shell scripts triggered by Claude Code tool events
- **Rules** — CLAUDE.md snippets that can be copy-pasted into project-level CLAUDE.md files
- **MCP Configs** — ready-to-paste MCP server snippets for `.claude/settings.json`
- **Settings Templates** — pre-built `.claude/settings.json` starters by project type
- **Workflows** — multi-agent orchestration patterns

## Directory Structure

```
.claude/commands/       # Slash commands
agents/                 # Sub-agents by category (core-development, code-review, testing, devops)
skills/                 # Skills by category (frontend, backend, data, workflow)
hooks/pre-tool/         # PreToolUse hook scripts
hooks/post-tool/        # PostToolUse hook scripts
rules/                  # CLAUDE.md snippet files
mcp/                    # MCP server config snippets
settings-templates/     # .claude/settings.json starters by project type
workflows/              # Multi-agent orchestration patterns
templates/              # Starter templates for new contributions
examples/               # Usage examples
docs/                   # Documentation
.github/                # PR and issue templates
```

## When Helping a Contributor Add Something New

If someone asks you to help create a new skill, agent, command, hook, MCP config, settings template, or workflow:

### Step 1: Read the contribution guide
Read `CONTRIBUTING.md` before doing anything else. It contains the folder placement rules, frontmatter requirements, and standards for all contribution types.

### Step 2: Use the right template
- New skill → copy `templates/skill-template.md` to `skills/<category>/`
- New agent → copy `templates/agent-template.md` to `agents/<category>/`
- New command → copy `templates/command-template.md` to `.claude/commands/`
- New workflow → follow the same frontmatter structure in `workflows/`
- New MCP config → use the JSON format with `_readme`, `_setup`, and `mcpServers` fields (see existing files in `mcp/`)
- New settings template → use the JSON format with `_readme`, `_usage`, and `permissions` fields (see existing files in `settings-templates/`)

### Step 3: Fill in all frontmatter
All `.md` files must have:
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

### Step 4: Update CATALOG.md
**This is mandatory.** After creating or modifying any file, update `CATALOG.md` by adding a row to the relevant section. Read the "How to Update This File" section at the bottom of `CATALOG.md` for the format.

Do not skip this step — reviewers check that CATALOG.md is updated as part of every PR.

### Step 5: Verify before finishing
- File uses kebab-case naming
- Placed in the correct folder (check `CONTRIBUTING.md` → Folder Placement table)
- No project-specific names, internal URLs, or credentials
- All frontmatter fields filled in
- CATALOG.md updated

## Frontmatter Schema

All skill/agent/command/workflow `.md` files must begin with:

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

See `CONTRIBUTING.md` for the full guide. Key rules:
- No company-specific project names, internal URLs, or credentials
- Generic enough to work across different projects
- Project-specific config should be read from local files (e.g., `DEVAPP.json`, `package.json`)
- MCP configs must use `$ENV_VAR` references — never hardcoded secrets
