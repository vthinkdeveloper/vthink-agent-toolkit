---
name: dev-server
description: >
  Start, stop, or restart the local dev server. Auto-detects the start command
  and port from package.json scripts or prompts the user. Supports start, stop,
  and restart actions. Invoke with /dev-server <start|stop|restart>.
version: 1.0.0
author: adharsh2208vthink
category: devops
tags: [dev-server, local, npm, port, workflow]
argument-hint: "<start|stop|restart>"
allowed-tools: Bash, Read
---

# Dev Server — Start / Stop / Restart

Manage the local development server. Supports three actions: `start`, `stop`, `restart`.

## Step 1: Parse the Action

Read `$ARGUMENTS` to determine the action: `start`, `stop`, or `restart`.

If no argument is provided or the argument is unrecognized, ask the user:
> "What would you like to do? start / stop / restart"

## Step 2: Detect Server Config

Auto-detect the start command and port from the project:

1. **Read `package.json`** — look for:
   - `scripts.start` — the start command (e.g., `node server.js`, `react-scripts start`)
   - `scripts.dev` — alternative dev command (prefer `dev` over `start` for frontend projects)
   - Any `PORT` env var references in the scripts

2. **Check for common config files** — look for port in:
   - `.env` or `.env.local` — `PORT=<number>`
   - `vite.config.js` / `webpack.config.js` — `port:` field
   - `server.js` / `app.js` / `index.js` — `listen(<port>)`

3. **Default fallback** — if no port is found, assume `3000` but inform the user.

4. **If no start command found** — ask the user:
   > "I couldn't find a start command. What command starts your server? (e.g., `npm run dev`, `python manage.py runserver`)"

## Step 3: Execute the Action

### start

1. Check if the detected port is already in use:
   ```bash
   lsof -ti:<port>
   ```
2. If the port is occupied, inform the user:
   > "Port <port> is already in use (PID <pid>). Run `/dev-server stop` first, or check if another instance is running."
   Stop here — do NOT start a second instance.
3. If the port is free, start the server in the background:
   ```bash
   <start-command> &
   ```
4. Wait 2 seconds, then verify the process is still running.
5. Confirm to the user: "Server started on port <port>. Running in background — you can keep using Claude Code."

### stop

1. Find the process using the detected port:
   ```bash
   lsof -ti:<port>
   ```
2. If a process is found, kill it:
   ```bash
   kill $(lsof -ti:<port>)
   ```
3. Confirm: "Server stopped (port <port> is now free)."
4. If nothing was running: "No server was running on port <port>."

### restart

1. Run the **stop** flow (kill any process on the port).
2. Wait 1 second.
3. Run the **start** flow (start the server in the background).
4. Confirm: "Server restarted on port <port>."
