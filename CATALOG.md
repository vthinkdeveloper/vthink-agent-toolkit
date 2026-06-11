# Toolkit Catalog

This file is the **single source of truth** for everything in the toolkit. When you add a new skill, agent, or playbook, **update this file as part of your PR**.

> Keep entries sorted alphabetically within each section.

---

## Skills

Workflow and domain knowledge prompts. Each skill lives at `skills/<name>/SKILL.md`.

| Name | File | Description |
|------|------|-------------|
| anonymize-prompt | [`skills/anonymize-prompt/SKILL.md`](skills/anonymize-prompt/SKILL.md) | Generate a privacy-safe, anonymized prompt for pasting into external tools without leaking proprietary details. |
| bdd-gherkin | [`skills/bdd-gherkin/SKILL.md`](skills/bdd-gherkin/SKILL.md) | Generate BDD Gherkin feature files from requirements through a collaborative clarifying conversation. |
| commit-push | [`skills/commit-push/SKILL.md`](skills/commit-push/SKILL.md) | Stage, generate a Conventional Commits message, get user approval, commit, and push. |
| commit-push-pr | [`skills/commit-push-pr/SKILL.md`](skills/commit-push-pr/SKILL.md) | Stage, commit, push, and open a pull request in one workflow. |
| conventions-check | [`skills/conventions-check/SKILL.md`](skills/conventions-check/SKILL.md) | Check code changes against project conventions discovered from the codebase itself. |
| generate-endpoint | [`skills/generate-endpoint/SKILL.md`](skills/generate-endpoint/SKILL.md) | Scaffold a complete CRUD endpoint adapted to your project's existing structure and conventions. |
| html-it | [`skills/html-it/SKILL.md`](skills/html-it/SKILL.md) | Convert a markdown document into a rich, standalone HTML file with embedded CSS — card-based sections, GitHub-ish color palette, opens in browser. |
| give-me-a-commit-message | [`skills/give-me-a-commit-message/SKILL.md`](skills/give-me-a-commit-message/SKILL.md) | Suggest a commit message from current changes without committing. |
| qa-guide | [`skills/qa-guide/SKILL.md`](skills/qa-guide/SKILL.md) | Generate a structured QA testing guide for a pull request. |
| ship | [`skills/ship/SKILL.md`](skills/ship/SKILL.md) | Conventions check + commit with ticket ID from branch name + push. |
| work-towards-alignment | [`skills/work-towards-alignment/SKILL.md`](skills/work-towards-alignment/SKILL.md) | Collaborative user–Claude alignment session on a plan, design, or PR review — probes foundational knowledge first, then walks claims one by one until the user explicitly signals alignment. |

---

## Agents

Specialised sub-agents with defined roles. Each agent lives at `agents/<name>/AGENT.md`.

| Name | File | Description |
|------|------|-------------|
| setup-wizard | [`agents/setup-wizard/AGENT.md`](agents/setup-wizard/AGENT.md) | Conversational onboarding agent — tours the toolkit and generates a personalised starter guide. |
| test-runner | [`agents/test-runner/AGENT.md`](agents/test-runner/AGENT.md) | Run the test suite, diagnose failures, fix source code, repeat until all tests pass. |

---

## Playbooks

Recipes for combining skills and agents. Place files in `playbooks/`.

| Name | File | Description |
|------|------|-------------|
| feature-development | [`playbooks/feature-development.md`](playbooks/feature-development.md) | BDD → implement → test → ship. Full cycle from feature description to pushed code. |
| plan-research-build | [`playbooks/plan-research-build.md`](playbooks/plan-research-build.md) | Plan first, research externally with anonymized prompts, build manually with line-by-line confidence. |
| pr-review-pipeline | [`playbooks/pr-review-pipeline.md`](playbooks/pr-review-pipeline.md) | Conventions check → test runner → QA guide. End-to-end PR review for a given PR number. |

---

## Slash Commands (Claude Code)

Invocable via `/command-name` in Claude Code. Files in `.claude/commands/`.

| Name | Invocation | File | Description |
|------|-----------|------|-------------|
| dev-server | `/dev-server <start\|stop\|restart>` | [`.claude/commands/dev-server.md`](.claude/commands/dev-server.md) | Manage the local dev server. Auto-detects start command and port from package.json. |

---

## Platforms — Claude Code Specific

Assets in `platforms/claude-code/` are Claude Code-specific and not portable to other runtimes.

### Hooks

| Name | File | Trigger | Description |
|------|------|---------|-------------|
| check-naming-conventions | [`platforms/claude-code/hooks/pre-tool/check-naming-conventions.sh`](platforms/claude-code/hooks/pre-tool/check-naming-conventions.sh) | Write, Edit | Enforces kebab-case (JS/TS), snake_case (Python), PascalCase (Java/components). Configurable via `.claude/naming-conventions.json`. |

### MCP Configurations

| Name | File | What it enables | Notes |
|------|------|-----------------|-------|
| filesystem | [`platforms/claude-code/mcp/filesystem.json`](platforms/claude-code/mcp/filesystem.json) | Scoped file access outside the project directory | Set allowed paths |
| github | [`platforms/claude-code/mcp/github.json`](platforms/claude-code/mcp/github.json) | Read/write GitHub issues, PRs, repos | Requires `$GITHUB_TOKEN` |
| postgres | [`platforms/claude-code/mcp/postgres.json`](platforms/claude-code/mcp/postgres.json) | Query a PostgreSQL database | Requires `$PG_CONNECTION_STRING` |
| puppeteer | [`platforms/claude-code/mcp/puppeteer.json`](platforms/claude-code/mcp/puppeteer.json) | Browser automation and web scraping | Downloads Chromium on first use |
| sqlite | [`platforms/claude-code/mcp/sqlite.json`](platforms/claude-code/mcp/sqlite.json) | Query a local SQLite database | Set db file path |

### Settings Templates

| Name | File | For |
|------|------|-----|
| java-spring | [`platforms/claude-code/settings-templates/java-spring.json`](platforms/claude-code/settings-templates/java-spring.json) | Java / Spring Boot (Maven) |
| nodejs | [`platforms/claude-code/settings-templates/nodejs.json`](platforms/claude-code/settings-templates/nodejs.json) | Node.js / Express backend |
| python | [`platforms/claude-code/settings-templates/python.json`](platforms/claude-code/settings-templates/python.json) | Python (pip / poetry / uv) |
| react | [`platforms/claude-code/settings-templates/react.json`](platforms/claude-code/settings-templates/react.json) | React frontend (CRA / Vite / Next.js) |

### Rules (CLAUDE.md snippets)

| Name | File | Description |
|------|------|-------------|
| file-organization | [`platforms/claude-code/rules/file-organization.md`](platforms/claude-code/rules/file-organization.md) | Instructs Claude to save plans/docs to `docs/` and follow existing directory structure. |
| planning-collaboration | [`platforms/claude-code/rules/planning-collaboration.md`](platforms/claude-code/rules/planning-collaboration.md) | Controls Plan Mode behaviour — wait for approval, share only meaningful findings. |

---

## Output Styles

| Name | File | Description |
|------|------|-------------|
| sharp | [`output-styles/sharp.md`](output-styles/sharp.md) | Pointed and explanatory — highlights best practices and direction changes without being verbose. |

---

## How to Update This File

When you open a PR with a new contribution, add a row to the relevant table:

- **Name** — the `name` field from your frontmatter
- **File** — relative path from repo root (e.g., `skills/my-skill/SKILL.md`)
- **Description** — the `description` field from your frontmatter

Reviewers check that this file is updated as part of every PR.
