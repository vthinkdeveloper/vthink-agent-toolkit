# vThink Agent Toolkit

> A curated toolkit of skills, agents, and workflows for building software with Agentic AI.

A collection of battle-tested workflows, agents, and skills ready to drop into any AI coding setup. Less setup. More building.

---

## Skills

| Skill | What it does |
|-------|-------------|
| [`commit-push`](skills/commit-push/SKILL.md) | Stage → generate Conventional Commit message → confirm → push |
| [`commit-push-pr`](skills/commit-push-pr/SKILL.md) | Stage → commit → push → open a PR with confirmed title and description |
| [`ship`](skills/ship/SKILL.md) | Conventions check + commit with ticket ID from branch + push |
| [`give-me-a-commit-message`](skills/give-me-a-commit-message/SKILL.md) | Suggest a commit message from staged diff without committing |
| [`conventions-check`](skills/conventions-check/SKILL.md) | Check code against conventions discovered from the codebase itself |
| [`qa-guide`](skills/qa-guide/SKILL.md) | Generate a structured QA test plan from a PR diff |
| [`bdd-gherkin`](skills/bdd-gherkin/SKILL.md) | Turn vague requirements into Given/When/Then Gherkin scenarios |
| [`anonymize-prompt`](skills/anonymize-prompt/SKILL.md) | Rewrite a technical question to strip all proprietary details |
| [`generate-endpoint`](skills/generate-endpoint/SKILL.md) | Scaffold a complete CRUD endpoint adapted to your project structure |

## Agents

| Agent | What it does |
|-------|-------------|
| [`test-runner`](agents/test-runner/AGENT.md) | Run the test suite, diagnose failures, fix source code, repeat until green |
| [`setup-wizard`](agents/setup-wizard/AGENT.md) | Onboarding agent — tours the toolkit and generates a personalised starter guide |

---

## Install

<details>
<summary><b>Claude Code</b></summary>

**Manual — copy a skill into your project:**
```bash
mkdir -p your-project/.claude/skills
cp path/to/vthink-agent-toolkit/skills/commit-push/SKILL.md \
   your-project/.claude/skills/commit-push.md
```

**Onboarding wizard:**
```bash
mkdir -p ~/.claude/agents
cp agents/setup-wizard/AGENT.md ~/.claude/agents/setup-wizard.md
```
Then say: *"Set up the vthink toolkit for this project"*

</details>

<details>
<summary><b>Cursor</b></summary>

Copy any `SKILL.md` into `.cursor/rules/` or reference the `skills/` directory in your Cursor rules config.

```bash
cp path/to/vthink-agent-toolkit/skills/conventions-check/SKILL.md \
   your-project/.cursor/rules/conventions-check.md
```

</details>

<details>
<summary><b>Windsurf</b></summary>

Add skill contents to your `.windsurfrules` file, or copy `SKILL.md` files into your project's rules directory.

</details>

<details>
<summary><b>Gemini CLI</b></summary>

Reference skill files in `GEMINI.md` for persistent context, or install directly:

```bash
gemini skills install https://github.com/vthinkdeveloper/vthink-agent-toolkit.git --path skills
```

</details>

---

## Directory Structure

```
vthink-agent-toolkit/
├── skills/                     # Skills — one folder per skill, always SKILL.md
│   ├── commit-push/SKILL.md
│   ├── ship/SKILL.md
│   └── ...
├── agents/                     # Agents — one folder per agent, always AGENT.md
│   ├── test-runner/AGENT.md
│   └── setup-wizard/AGENT.md
├── playbooks/                  # Recipes for combining skills and agents
├── platforms/
│   └── claude-code/            # Claude Code-specific assets
│       ├── hooks/              # Pre/post-tool shell scripts
│       ├── mcp/                # MCP server config snippets
│       ├── settings-templates/ # .claude/settings.json starters by project type
│       └── rules/              # CLAUDE.md snippets
├── .claude/commands/           # Slash commands (Claude Code)
└── templates/                  # Starter templates for contributors
```

---

## How to Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md). The short version:

1. Create `skills/<your-skill-name>/SKILL.md` or `agents/<your-agent-name>/AGENT.md`
2. Use only `name` and `description` frontmatter
3. Update `CATALOG.md`
4. Open a PR

---

## License

[MIT](LICENSE)
