# CLAUDE.md — vthink-agent-toolkit

This file provides Claude Code with context about this repository. For agent-runtime-agnostic instructions, see [AGENTS.md](AGENTS.md).

## What This Repo Is

`vthink-agent-toolkit` is a collection of agent-agnostic skills, agents, and workflows. Claude Code is one supported runtime — not the assumed one. Claude Code-specific assets (hooks, MCP configs, settings templates, rules) live in `platforms/claude-code/`.

## Directory Structure

```
skills/<name>/SKILL.md           # Skills — portable across all runtimes
agents/<name>/AGENT.md           # Agents — portable across all runtimes
workflows/                        # Multi-agent orchestration patterns
platforms/claude-code/            # Claude Code-specific assets
  hooks/                          # Pre/post-tool shell scripts
  mcp/                            # MCP server config snippets
  settings-templates/             # .claude/settings.json starters
  rules/                          # CLAUDE.md snippets
.claude/commands/                 # Slash commands (Claude Code)
output-styles/                    # Response style files (tone, structure, formatting)
templates/                        # Starter templates for contributors
```

## Tour

If a user says **"I'd like a tour"**, install the setup wizard and invoke it:

```bash
mkdir -p ~/.claude/agents
cp agents/setup-wizard/AGENT.md ~/.claude/agents/setup-wizard.md
```

Then invoke the setup-wizard agent.

## When Helping a Contributor Add Something New

1. Read `CONTRIBUTING.md`
2. Use the right template from `templates/`
3. Frontmatter must have only `name` and `description` — nothing else
4. Skills go in `skills/<name>/SKILL.md`, agents in `agents/<name>/AGENT.md`
5. Claude Code-specific contributions go in `platforms/claude-code/`
6. **Update `CATALOG.md`** — mandatory, reviewers check this
