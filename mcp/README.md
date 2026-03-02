# MCP Server Configurations

Ready-to-paste MCP (Model Context Protocol) server snippets for `.claude/settings.json`.

## What is MCP?

MCP servers extend Claude Code with additional tools and data sources — databases, browsers, APIs, filesystems, and more. Each snippet here is a self-contained block you copy into the `mcpServers` section of your project's `.claude/settings.json`.

## How to Use

1. Pick the MCP server(s) you need from the files in this directory
2. Open (or create) `.claude/settings.json` in your project root
3. Add the snippet under `mcpServers`:

```json
{
  "mcpServers": {
    "github": { ...paste snippet here... },
    "postgres": { ...paste snippet here... }
  }
}
```

4. Restart Claude Code — the new tools will be available

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
