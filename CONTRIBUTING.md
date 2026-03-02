# Contributing to vthink-claudecode-toolkit

Thanks for contributing! This toolkit grows through shared expertise — the more engineers contribute, the more powerful it becomes for everyone.

---

## Ways to Contribute

- **New Skill** — domain knowledge or workflow automation for Claude to follow
- **New Agent** — a specialized sub-agent with a defined role and responsibilities
- **New Command** — a slash command (`.md` file in `.claude/commands/`)
- **New Hook** — a shell script triggered by Claude Code events
- **Bug Fix / Improvement** — fix a broken prompt, improve clarity, update stale instructions
- **Documentation** — improve README, getting-started, or inline comments

---

## Contribution Standards

### File Naming
Use **kebab-case** for all files: `generate-endpoint.md`, `pre-commit-check.sh`

### Required Frontmatter
All `.md` contribution files (skills, agents, commands) must include this frontmatter block at the top:

```yaml
---
name: kebab-case-name
description: One-line description of what this does
version: 1.0.0
author: your-github-username
category: <see valid values per type>
tags: [tag1, tag2]
---
```

**Valid categories:**
- Agents: `core-development`, `code-review`, `testing`, `devops`
- Skills: `frontend`, `backend`, `data`
- Commands: `git`, `quality`, `generation`, `devops`, `utility`
- Hooks: `pre-tool`, `post-tool`

### No Sensitive or Proprietary Information
- No internal URLs, credentials, API keys, or company-specific project names
- Generalize references to file paths, service names, and internal tooling
- When in doubt, use config-file-driven approaches (e.g., read settings from a local `.json` file)

---

## Folder Placement

| Contribution Type | Folder |
|-------------------|--------|
| Agent | `agents/<category>/` |
| Skill | `skills/<category>/` |
| Slash Command | `.claude/commands/` |
| Pre-tool Hook | `hooks/pre-tool/` |
| Post-tool Hook | `hooks/post-tool/` |
| CLAUDE.md snippet | `rules/` |

---

## Template Usage

Before writing from scratch, copy the appropriate template:

```bash
# For a new agent
cp templates/agent-template.md agents/<category>/my-agent.md

# For a new skill
cp templates/skill-template.md skills/<category>/my-skill.md

# For a new slash command
cp templates/command-template.md .claude/commands/my-command.md
```

Fill in all frontmatter fields and replace placeholder sections with real content.

---

## PR Process

1. Fork this repository
2. Create a branch: `git checkout -b add/my-skill-name`
3. Add your contribution in the correct folder using the template
4. Fill out the PR template when opening the pull request
5. A teammate will review within a few business days

---

## Review Criteria

Reviewers will check:

- **Clarity** — does the prompt/instruction clearly describe behavior?
- **Uniqueness** — does this add something not already in the toolkit?
- **Tested** — has the author verified it works in Claude Code?
- **Generic** — no project-specific assumptions baked in (or uses config files to abstract them)
- **Frontmatter** — all required fields present and accurate
- **Correct placement** — file is in the right category folder
- **Catalog updated** — a row has been added to the relevant table in `CATALOG.md`
