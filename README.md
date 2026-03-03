# vthink-claudecode-toolkit

> A shared toolkit of Claude Code skills, agents, slash commands, and hooks for the vthink engineering team.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-blue)](https://github.com/anthropics/claude-code)

---

## Start Here

The fastest way to get set up is to **open this repo in Claude Code** — it'll
offer to run the setup wizard automatically.

Or trigger it yourself at any time:

```bash
mkdir -p ~/.claude/agents && cp agents/utility/setup-wizard.md ~/.claude/agents/
```

Then open any project in Claude Code and say:
> *"Set up the vthink toolkit for this project"*

The wizard learns about your role, scans your project, and builds you a
personalised reference guide.

---

## What's in the Toolkit

Browse the full catalog: **[CATALOG.md](CATALOG.md)**

| Category | Count | Location |
|----------|-------|----------|
| Agents | — | [`agents/`](agents/) |
| Skills | — | [`skills/`](skills/) |
| Slash Commands | — | [`.claude/commands/`](.claude/commands/) |
| Hooks | — | [`hooks/`](hooks/) |
| Rules | — | [`rules/`](rules/) |
| MCP Configs | — | [`mcp/`](mcp/) |
| Settings Templates | — | [`settings-templates/`](settings-templates/) |
| Workflows | — | [`workflows/`](workflows/) |

---

## Quick Install

### Copy a single skill into your project

```bash
cp path/to/vthink-claudecode-toolkit/skills/backend/my-skill.md \
   your-project/.claude/skills/
```

### Copy all slash commands into your project

```bash
cp vthink-claudecode-toolkit/.claude/commands/*.md \
   your-project/.claude/commands/
```

### Use a hook

```bash
cp vthink-claudecode-toolkit/hooks/pre-tool/my-hook.sh \
   your-project/.claude/hooks/pre-tool/
chmod +x your-project/.claude/hooks/pre-tool/my-hook.sh
```

> See [`CATALOG.md`](CATALOG.md) to browse all available tools.

---

## Directory Guide

```
vthink-claudecode-toolkit/
├── .claude/commands/       # Slash commands — invoke with /command-name in Claude Code
├── agents/                 # Sub-agent definitions, organized by category
│   ├── core-development/
│   ├── code-review/
│   ├── testing/
│   └── devops/
├── skills/                 # Skill files — domain/workflow knowledge for Claude
│   ├── frontend/
│   ├── backend/
│   └── data/
├── hooks/                  # Shell scripts triggered by Claude Code events
│   ├── pre-tool/           # Run before a tool executes
│   └── post-tool/          # Run after a tool executes
├── rules/                  # CLAUDE.md snippets — always-follow instructions
├── mcp/                    # MCP server config snippets (copy into settings.json)
├── settings-templates/     # Pre-built .claude/settings.json by project type
├── workflows/              # Multi-agent orchestration patterns
├── templates/              # Starter templates for new contributions
├── examples/               # Real-world usage examples
└── docs/                   # Documentation
```

---

## Featured Contributions

_Add standout skills, agents, or commands here as the toolkit grows._

---

## How to Contribute

We welcome contributions from any vthink engineer! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Standards for file naming and frontmatter
- Which folder your contribution belongs in
- How to use the starter templates
- The PR review process

---

## License

[MIT](LICENSE)
