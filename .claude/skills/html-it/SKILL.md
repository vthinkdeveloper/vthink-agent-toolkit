---
name: html-it
description: >
  Convert a markdown document (plan, design doc, alignment doc, review notes) into a
  rich, standalone HTML file with embedded CSS — styled to match the project's existing
  HTML docs (light theme, system fonts, card-based sections, GitHub-ish color palette).
  Inspired by https://thariqs.github.io/html-effectiveness/ — the goal is a self-contained
  .html the reader opens in a browser instead of squinting at a wall of markdown. Invoke
  with /html-it [path-to-md]. If no path is given, defaults to the most recently
  modified .md in ~/.claude/plans/ or the current working directory.
argument-hint: "[optional: path to a .md file]"
allowed-tools: Read, Write, Bash, Glob
---

# html-it

Render a markdown document as a standalone, self-contained HTML file with embedded CSS — the kind of document the user can open in a browser, screenshot, or share via Slack/email.

The gallery at https://thariqs.github.io/html-effectiveness/ is the **aspirational style reference**: rich, scannable, opinionated layout — not a generic markdown→HTML dump. When the source markdown has structure (sections, decisions, tables, status, checklists, before/after), reflect that structure visually with cards, badges, pills, dividers — not just `<h2>` and `<p>`.

## Workflow

### Step 1: Resolve the source file

- If the user passed a path as argument, use it.
- Otherwise, glob for the most recently modified `.md` file in:
  1. `~/.claude/plans/`
  2. The current working directory's `docs/` folder
  3. The current working directory itself

Confirm the chosen file to the user in one line ("Rendering: `path/to/file.md`") before proceeding. If multiple plausible matches, ask via AskUserQuestion.

### Step 2: Read and understand the structure

Read the entire markdown file. Identify the document's logical sections:

- **Title / context** — usually the H1 + intro paragraph
- **Decisions / recommendations** — call these out with a card or callout
- **Tables** — render as styled tables (zebra rows, subtle borders)
- **Code blocks / file paths** — monospace, light gray background
- **Open questions / decisions to confirm** — render as a distinct "needs input" block
- **Verification / test plan / checklist** — render as a styled checklist with checkboxes
- **Before/after comparisons** — render side-by-side or as a two-column table
- **Status / state** — render as a colored pill

This is **not** a literal markdown-to-HTML conversion. You're authoring an HTML document that *communicates the same content* in a richer form.

### Step 3: Apply the project's established style

Use these CSS tokens (matching the existing HTML docs in `docs/wcbi-*-alignment.html` in this user's projects). Put the full `<style>` block inline in `<head>`:

```css
:root {
  --bg: #fafaf7;
  --fg: #1f2328;
  --muted: #6e7681;
  --border: #d0d7de;
  --accent: #0969da;
  --ok: #1a7f37;
  --ok-tint: #dafbe1;
  --warn: #bf8700;
  --warn-tint: #fff5d6;
  --bad: #cf222e;
  --bad-tint: #fff1f0;
  --code-bg: #eef1f4;
  --card: #ffffff;
}
* { box-sizing: border-box; }
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif;
  color: var(--fg);
  background: var(--bg);
  line-height: 1.55;
  max-width: 920px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 4rem;
  font-size: 16px;
}
h1 { font-size: 1.7rem; margin: 0 0 .3rem; letter-spacing: -.01em; }
h2 { font-size: 1.2rem; margin: 2.4rem 0 .8rem; padding-bottom: .3rem; border-bottom: 1px solid var(--border); }
h3 { font-size: 1.02rem; margin: 1.4rem 0 .5rem; color: var(--fg); }
p, li { margin: .35rem 0; }
code, pre { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: .9em; }
code { background: var(--code-bg); padding: .12em .35em; border-radius: 4px; }
pre { background: var(--code-bg); padding: .9rem 1rem; border-radius: 6px; overflow-x: auto; }
pre code { background: none; padding: 0; }
table { border-collapse: collapse; width: 100%; margin: .8rem 0 1.2rem; font-size: .94rem; }
th, td { border: 1px solid var(--border); padding: .5rem .7rem; text-align: left; vertical-align: top; }
th { background: var(--code-bg); font-weight: 600; }
tr:nth-child(even) td { background: #fcfcfa; }
blockquote { border-left: 3px solid var(--accent); margin: .8rem 0; padding: .2rem 0 .2rem 1rem; color: var(--muted); }
.meta { color: var(--muted); font-size: .9rem; margin-bottom: 1.6rem; }
.card { background: var(--card); border: 1px solid var(--border); border-radius: 8px; padding: 1rem 1.2rem; margin: 1rem 0; }
.pill { display: inline-block; padding: .15rem .6rem; border-radius: 999px; font-size: .82rem; font-weight: 600; }
.pill.ok { background: var(--ok-tint); color: var(--ok); }
.pill.warn { background: var(--warn-tint); color: var(--warn); }
.pill.bad { background: var(--bad-tint); color: var(--bad); }
.callout { border-left: 4px solid var(--accent); background: #f3f7fc; padding: .7rem 1rem; border-radius: 0 6px 6px 0; margin: 1rem 0; }
.callout.warn { border-left-color: var(--warn); background: #fffbe6; }
.callout.ok { border-left-color: var(--ok); background: var(--ok-tint); }
.callout.bad { border-left-color: var(--bad); background: var(--bad-tint); }
.checklist { list-style: none; padding-left: 0; }
.checklist li { background: var(--card); border: 1px solid var(--border); border-radius: 6px; padding: .55rem .8rem; margin: .35rem 0; display: flex; gap: .6rem; align-items: flex-start; }
.checklist li::before { content: "☐"; color: var(--muted); font-size: 1.1rem; line-height: 1; }
.checklist li.done::before { content: "☑"; color: var(--ok); }
.kbd { background: var(--code-bg); border: 1px solid var(--border); border-bottom-width: 2px; border-radius: 4px; padding: .1rem .4rem; font-family: ui-monospace, monospace; font-size: .85em; }
```

Use these classes liberally — they're the building blocks of the visual language:

- `.card` — bordered white container for grouped content
- `.callout` (+ `.warn` / `.ok` / `.bad`) — for highlighted notes, recommendations, warnings
- `.pill` (+ `.ok` / `.warn` / `.bad`) — for status labels (e.g., "DONE", "OPEN", "BLOCKED")
- `.checklist` — for verification steps, test plans, action items
- `.meta` — for the byline / metadata strip under the title

### Step 4: Structural patterns to apply

| Markdown shape | HTML treatment |
|---|---|
| H1 + intro paragraph | Title block + `.meta` strip (filename, generated-on date) |
| H2 "Context" / "Background" / "Why" | Normal H2 |
| "Decision:" / "Recommendation:" lines | Wrap in `.callout` (default accent) |
| "Open decisions" / "Questions" section | Wrap each item in a `.card`, prefix with `<span class="pill warn">OPEN</span>` |
| Code blocks (multi-line) | `<pre><code>` with code-bg styling |
| Inline `code` / file paths / class names | `<code>` |
| Tables (`\|---\|`) | Styled `<table>` with zebra rows |
| Verification / test plan | `.checklist` with `<li>` items |
| Before/After (paragraphs labeled) | Two-column flex or table |
| Quoted insight blocks (`> Best practice:` etc.) | `.callout` with appropriate variant |

### Step 5: Write the HTML file

- Output path: same directory as source, same basename, `.html` extension. Example: `~/.claude/plans/sendgrid-default-email-config.md` → `~/.claude/plans/sendgrid-default-email-config.html`
- The file MUST be fully self-contained: no external CSS, no external fonts, no JavaScript dependencies (vanilla inline `<script>` is fine if it adds value).
- Include `<meta charset="UTF-8">` and `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- `<title>` = the H1 text of the source document.

### Step 6: Open in browser

After writing the file, open it:

```bash
open <path-to-html>
```

Confirm to the user with the path written and that it opened.

## Constraints

- **Do not invent content.** Render what's in the source markdown. You can re-shape (group related bullets into a card, promote a "Decision:" line into a callout), but don't add new claims, facts, or sections.
- **Do not strip content.** Every meaningful sentence in the source should appear somewhere in the HTML.
- **Self-contained only.** No CDN links, no Google Fonts, no external images. The file should render identically offline.
- **No emojis unless the source has them.**
- **Keep CSS scoped.** Embed the `<style>` block in `<head>`; do not inline styles on individual elements unless absolutely necessary.
- **No JS unless it adds clear value** — e.g., a "copy to clipboard" button on a code block is fine; an animated hero is not.

## Output

Brief one-liner to the user: `Wrote <path>.html (opened in browser).` No long summary.
