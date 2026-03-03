# CLAUDE.md — vthink-claudecode-toolkit

This file provides Claude Code with context about this repository's structure and purpose.

## First Time Here?

If the user has just cloned this repo and hasn't given you a specific task yet,
proactively greet them and offer to run the setup wizard:

> "Hi! Looks like you just opened the vthink toolkit. Want me to run the setup
> wizard? It takes 3–4 minutes and gives you a personalised tour of everything
> in the toolkit, starred for your role and stack.
>
> To get started, I just need to copy the wizard into your global Claude agents
> folder. Shall I do that now?"

If they say yes — run:
```bash
mkdir -p ~/.claude/agents
cp agents/utility/setup-wizard.md ~/.claude/agents/
```
Then tell them: "Done! Now open any project in Claude Code and say
'Set up the vthink toolkit for this project' — the wizard will take it from there."

If they already have a specific task in mind, skip this and help them directly.

---

## Getting Started — Run the Setup Wizard

If you've just cloned this repo and want to set up the toolkit in a project, the fastest way is the **setup-wizard** agent.

**One-time install** (makes the wizard available in every project on this machine):

```bash
mkdir -p ~/.claude/agents
cp agents/utility/setup-wizard.md ~/.claude/agents/
```

Then open any project in Claude Code and say:

> *"Set up the vthink toolkit for this project"*

The wizard will give you a guided tour of all available tools, star the ones most relevant to your role and stack, and generate a personalised `claude-starter-guide.md` reference file for you to keep.

---

## What This Repo Is

`vthink-claudecode-toolkit` is a curated collection of Claude Code customizations for the vthink engineering team. It contains:

- **Agents** — sub-agent definitions with specific roles and responsibilities
- **Skills** — workflow and domain knowledge prompts
- **Slash Commands** — `.md` files in `commands/` invocable as `/command-name` once installed into a project's `.claude/commands/`
- **Hooks** — shell scripts triggered by Claude Code tool events
- **Rules** — CLAUDE.md snippets that can be copy-pasted into project-level CLAUDE.md files
- **MCP Configs** — ready-to-paste MCP server snippets for `.claude/settings.json`
- **Settings Templates** — pre-built `.claude/settings.json` starters by project type
- **Workflows** — multi-agent orchestration patterns

## Directory Structure

```
.claude/commands/       # Slash commands
agents/                 # Sub-agents by category (core-development, code-review, testing, devops, utility)
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
