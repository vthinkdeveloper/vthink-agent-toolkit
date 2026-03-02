# Getting Started with vthink-claudecode-toolkit

This guide walks you through finding, installing, and using components from the toolkit in your own projects.

---

## Prerequisites

- [Claude Code](https://github.com/anthropics/claude-code) installed and configured
- Basic familiarity with Claude Code's `.claude/` directory structure

---

## Finding the Right Component

Browse the repository:

| Looking for... | Go to |
|---------------|-------|
| A specialized Claude persona (e.g., "code reviewer") | [`agents/`](../agents/) |
| Domain or workflow automation (e.g., "generate an API endpoint") | [`skills/`](../skills/) |
| A slash command (e.g., `/deploy-check`) | [`.claude/commands/`](../.claude/commands/) |
| A pre/post tool hook | [`hooks/`](../hooks/) |
| An always-follow rule snippet | [`rules/`](../rules/) |

---

## Installing a Skill

1. Find the skill you want in `skills/<category>/skill-name.md`
2. Copy it into your project's Claude skills directory:

```bash
mkdir -p your-project/.claude/skills
cp vthink-claudecode-toolkit/skills/backend/skill-name.md \
   your-project/.claude/skills/
```

3. Reference the skill in your project's `CLAUDE.md` or invoke it directly in Claude Code.

---

## Installing a Slash Command

1. Find the command in `.claude/commands/command-name.md`
2. Copy it into your project's commands directory:

```bash
mkdir -p your-project/.claude/commands
cp vthink-claudecode-toolkit/.claude/commands/command-name.md \
   your-project/.claude/commands/
```

3. In Claude Code, invoke it with `/command-name`.

---

## Installing an Agent

1. Find the agent definition in `agents/<category>/agent-name.md`
2. Copy it into your project:

```bash
mkdir -p your-project/.claude/agents
cp vthink-claudecode-toolkit/agents/testing/agent-name.md \
   your-project/.claude/agents/
```

---

## Installing a Hook

1. Find the hook script in `hooks/pre-tool/` or `hooks/post-tool/`
2. Copy it and make it executable:

```bash
mkdir -p your-project/.claude/hooks/pre-tool
cp vthink-claudecode-toolkit/hooks/pre-tool/hook-name.sh \
   your-project/.claude/hooks/pre-tool/
chmod +x your-project/.claude/hooks/pre-tool/hook-name.sh
```

3. Configure the hook in your project's Claude Code settings.

---

## Using a Rules Snippet

1. Find the snippet in `rules/`
2. Copy the contents into your project's `CLAUDE.md` file.

---

## Contributing Back

If you improve a component or create something new, please contribute it back! See [CONTRIBUTING.md](../CONTRIBUTING.md) for the process.

---

## Getting Help

Open a GitHub issue or ping the team in the engineering Slack channel.
