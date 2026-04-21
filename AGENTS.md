# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Windsurf, Gemini CLI, OpenCode, etc.) when working with code in this repository.

## Repository Overview

`vthink-agent-toolkit` is a collection of production-grade skills, agents, and workflows for AI coding agents. Skills and agents are plain natural-language procedural instructions — they work in any agent runtime that can read markdown files.

## Structure

```
skills/<skill-name>/SKILL.md     # Skills — invoke by describing what you want
agents/<agent-name>/AGENT.md     # Agents — specialised sub-agents with a defined role
.claude/commands/                # Slash commands (Claude Code)
platforms/claude-code/           # Claude Code-specific: hooks, settings-templates, mcp, rules
workflows/                       # Multi-agent orchestration patterns
output-styles/                   # Response style files controlling tone and formatting
```

## When Working in This Repo

If a task matches a skill, invoke it. Skills are located at `skills/<skill-name>/SKILL.md`.

### Intent → Skill Mapping

| What you're doing | Use this skill |
|---|---|
| Commit and push changes | `commit-push` or `ship` |
| Commit, push, and open a PR | `commit-push-pr` |
| Just need a commit message | `give-me-a-commit-message` |
| Check code against conventions | `conventions-check` |
| Write BDD / Gherkin scenarios | `bdd-gherkin` |
| Generate a QA test plan for a PR | `qa-guide` |
| Scaffold a CRUD endpoint | `generate-endpoint` |
| Anonymize a prompt for external tools | `anonymize-prompt` |

## Contribution Rules

- All skill/agent files must have `name` and `description` frontmatter only
- Skills go in `skills/<name>/SKILL.md`, agents in `agents/<name>/AGENT.md`
- Claude Code-specific assets (hooks, settings, MCP configs, rules) go in `platforms/claude-code/`
- Update `CATALOG.md` after every addition
- See `CONTRIBUTING.md` for full standards
