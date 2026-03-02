# MCP Server Configurations

Ready-to-paste MCP (Model Context Protocol) server snippets for `.claude/settings.json`.

## What is MCP?

MCP servers extend Claude Code with additional tools and data sources — databases, browsers, APIs, filesystems, and more. Each snippet here is a self-contained block you copy into the `mcpServers` section of your project's `.claude/settings.json`.

## How to Use

Each file in this directory contains a JSON object with two parts:
- `_readme` / `_setup` / `_security` — documentation only (ignored by Claude Code)
- `mcpServers` — the actual config block to paste

**Steps:**

1. Open the `.json` file for the server you want
2. Copy **only the `mcpServers` block** (not the `_readme`/`_setup` keys)
3. Open (or create) `.claude/settings.json` in your project root
4. Paste under the top-level `mcpServers` key:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_TOKEN" }
    }
  }
}
```

5. Set any required environment variables (see each file's `_setup` notes)
6. Restart Claude Code — the new tools will be available

## Available Configs

| File | Server | What it enables |
|------|--------|-----------------|
| `github.json` | GitHub | Read/write issues, PRs, repos via GitHub API |
| `filesystem.json` | Filesystem | Scoped file access beyond the project directory |
| `postgres.json` | PostgreSQL | Query a Postgres database directly |
| `sqlite.json` | SQLite | Query a local SQLite database |
| `puppeteer.json` | Puppeteer | Browser automation and web scraping |

## Security Notes

- Never commit tokens or passwords — use environment variable references (`$ENV_VAR`) instead
- Scope filesystem access to the minimum directories needed
- Use read-only database users where possible
