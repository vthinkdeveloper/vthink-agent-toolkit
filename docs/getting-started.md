# Getting Started with vthink-claudecode-toolkit

This is a reference guide for the extension types in the toolkit. For a personalised walkthrough, run the [setup wizard](../agents/utility/setup-wizard.md).

---

## Extension Types

| Type | What it does | Install location |
|------|--------------|-----------------|
| **Skill** | A workflow Claude follows when you ask for it (e.g. `commit-push`) | `.claude/skills/` |
| **Agent** | A specialised sub-Claude with its own role and tools | `.claude/agents/` |
| **Slash Command** | A `/command-name` shortcut backed by a `.md` prompt file | `.claude/commands/` |
| **Hook** | A shell script that runs before/after Claude uses a tool | `.claude/hooks/pre-tool/` or `.claude/hooks/post-tool/` |
| **Rule** | A CLAUDE.md snippet Claude reads at every session start | Paste into your `CLAUDE.md` |
| **MCP Config** | JSON that connects Claude to an external tool (GitHub, DB, browser) | Paste `mcpServers` block into `.claude/settings.json` |

---

## Quick Install Examples

```bash
# Copy a skill
cp path/to/vthink-claudecode-toolkit/skills/workflow/commit-push.md .claude/skills/

# Copy an agent
cp path/to/vthink-claudecode-toolkit/agents/testing/test-runner.md .claude/agents/

# Copy a slash command
cp path/to/vthink-claudecode-toolkit/.claude/commands/ship.md .claude/commands/

# Install a hook
cp path/to/vthink-claudecode-toolkit/hooks/pre-tool/check-naming-conventions.sh \
   .claude/hooks/pre-tool/
chmod +x .claude/hooks/pre-tool/check-naming-conventions.sh
```

Claude Code automatically loads everything under `.claude/` at session start — no extra configuration needed.

---

## Prerequisites

- [Claude Code](https://github.com/anthropics/claude-code) installed (`npm install -g @anthropic-ai/claude-code`)
- A local clone of `vthink-claudecode-toolkit`

---

## Contributing Back

If you improve a component or create something new, please contribute it back. See [CONTRIBUTING.md](../CONTRIBUTING.md) for the process.
