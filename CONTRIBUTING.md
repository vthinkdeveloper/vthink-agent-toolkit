# Contributing to vthink-agent-toolkit

Thanks for contributing! Skills and agents here should be useful across any AI coding agent runtime — not tied to Claude Code specifically.

---

## Ways to Contribute

- **New Skill** — a workflow or domain knowledge prompt (`skills/<name>/SKILL.md`)
- **New Agent** — a specialised sub-agent with a defined role (`agents/<name>/AGENT.md`)
- **New Workflow** — a multi-agent orchestration pattern (`workflows/`)
- **Claude Code-specific** — hooks, MCP configs, settings templates, rules (`platforms/claude-code/`)
- **Bug Fix / Improvement** — fix a broken prompt, improve clarity, update stale instructions
- **Documentation** — improve README, getting-started, or inline docs

---

## File Structure

Skills and agents each get their own folder:

```
skills/<skill-name>/SKILL.md
agents/<agent-name>/AGENT.md
```

Use **kebab-case** for folder and file names.

---

## Frontmatter

All skill and agent `.md` files require only two frontmatter fields:

```yaml
---
name: kebab-case-name
description: What this does. Use when <trigger conditions>.
---
```

Do **not** include `version`, `author`, `category`, `tags`, or `allowed-tools` — these are runtime-specific and don't belong in the portable skill/agent definition.

---

## Skill Quality Bar

Skills should be:

- **Specific** — actionable steps, not vague advice
- **Verifiable** — clear exit criteria
- **Generic** — no project-specific names, internal URLs, or hardcoded credentials
- **Minimal** — only the content needed to guide the agent correctly

---

## Folder Placement

| Contribution Type | Folder |
|---|---|
| Skill | `skills/<name>/SKILL.md` |
| Agent | `agents/<name>/AGENT.md` |
| Workflow | `workflows/` |
| Slash Command (Claude Code) | `.claude/commands/` |
| Hook (Claude Code) | `platforms/claude-code/hooks/pre-tool/` or `post-tool/` |
| MCP Config (Claude Code) | `platforms/claude-code/mcp/` |
| Settings Template (Claude Code) | `platforms/claude-code/settings-templates/` |
| CLAUDE.md Snippet (Claude Code) | `platforms/claude-code/rules/` |
| Output Style | `output-styles/<name>.md` |

---

## Template Usage

```bash
# New skill
cp templates/skill-template.md skills/<my-skill-name>/SKILL.md

# New agent
cp templates/agent-template.md agents/<my-agent-name>/AGENT.md
```

---

## Sensitive Information

- No internal URLs, credentials, API keys, or company-specific project names
- MCP configs must use `$ENV_VAR` references — never hardcoded secrets
- Skills should read project-specific config from local files (e.g., `package.json`) rather than hardcoding assumptions

---

## PR Process

1. Fork this repository
2. Create a branch: `git checkout -b add/<skill-name>`
3. Add your contribution using the template
4. Update `CATALOG.md` — this is mandatory, reviewers check it
5. Open a PR using the PR template

---

## Review Criteria

- **Clarity** — does the instruction clearly describe the behavior?
- **Uniqueness** — does this add something not already in the toolkit?
- **Tested** — has the author verified it works?
- **Generic** — no project-specific assumptions baked in
- **Frontmatter** — only `name` and `description`, both filled in
- **Correct placement** — file is in the right folder
- **Catalog updated** — a row has been added to `CATALOG.md`
