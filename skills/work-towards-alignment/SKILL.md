---
name: work-towards-alignment
description: Run a collaborative session that actively works toward user–Claude alignment on a plan, design, or PR review. Bidirectional and user-paced — Claude first probes the user's foundational knowledge in chat (teaching where needed), THEN writes the alignment doc reflecting what was learned, THEN walks through each claim with the foundation already in place. Tracks state in docs/<topic>-alignment.md. Use when the user says "align me", "work towards alignment", "make sure we're on the same page about <plan>", "I need to understand this before approving", or invokes /work-towards-alignment.
---

# work-towards-alignment

Run a collaborative alignment session between you and the user about a plan, design, or PR review. The session ends only when the **user explicitly signals alignment** — not when you decide.

This skill is built on the assumption that **alignment requires genuine understanding, not nodding-through**. Each load-bearing claim depends on foundational knowledge the user may or may not already have. The skill runs in two phases:

- **Phase A (chat-only):** probe the user's foundational knowledge in chat, teach where needed, and record what we converged on in working memory.
- **Phase B (write artefacts + walk claims):** create the alignment doc reflecting what Phase A established, then present each claim with the foundation already in place.

This ordering matters: **the alignment doc should reflect the conversation, not predict it.**

## Core principles

- **Collaborative, not autonomous.** No Stop hooks. No background loops. No pestering.
- **User-paced.** They drive. Go silent between turns. Respond when prompted.
- **Teach before aligning.** Each item has prerequisite knowledge the user must hold to evaluate it. Probe first in chat; teach if needed; only then write the doc and present the claim.
- **Doc reflects, not predicts.** Phase A happens before any file is created. The alignment doc gets written once the basics conversation has surfaced what the user knows. Prerequisites the user already understood appear as `(known)`; prerequisites we taught appear with a summary in the Q&A log.
- **Durable.** Once written, all progress lives in `docs/<topic>-alignment.html` (the primary, living artefact). The session survives across Claude Code sessions because the HTML is the canonical source of state.
- **User has final say.** They can waive items, override, skip Phase A entirely ("just write the doc"), or end the session early. Never declare alignment unilaterally.
- **HTML is the primary artefact.** Per Anthropic's ["The unreasonable effectiveness of HTML"](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html): humans don't read 100-line markdown files, but they DO scan rich HTML with tables, color-coded badges, callouts, and interactive elements. Alignment sessions accumulate exactly that kind of structured content (checklist + Q&A + decisions + basics badges) — HTML is the right medium, markdown is the wrong one. A frozen `.md` snapshot may exist as a git-diffable audit trail but is NEVER the live working document.

## Inputs

- Argument: a path to an existing plan/design doc (e.g. `docs/wcbi-hateoas-json-shape-regression.md`), or a short topic name, or a description of the source artefact (PR comments, review feedback, etc.).
- If the argument is unclear, ask the user to specify before doing anything else.

## Workflow

The workflow has TWO phases. **Phase A is chat-only** — no files are written. **Phase B writes the alignment artefacts** only after Phase A has surfaced what the user already knows.

---

### Phase A — Chat-only preparation

#### Step 1 — Internally extract claims and prerequisites

Read the source artefact (plan, PR comments, design doc). Identify:

- **5–10 load-bearing claims** the user must actively agree with:
  - "The root cause is X" (factual claim)
  - "We will fix it by doing Y, not Z" (decision)
  - "Risk W is acceptable because V" (trade-off)
  - "We are NOT touching files A, B, C" (scope)
  - "Verification is done by running Q" (process)
- **Per-claim prerequisites** — the foundational concepts the user must understand to evaluate the claim. Concrete and nameable.

Good prerequisites:
- For "we install our converter at index 0": *content negotiation order, `HttpMessageConverter.canWrite` contract, how Spring picks a converter*
- For "the root cause is the bean-definition race": *`@Configuration` processing order, `BeanDefinitionRegistrar` vs `@Bean` methods, `DelegatingWebMvcConfiguration`*
- For "we accept the `*/*` known limitation": *what `*/*` means in HTTP `Accept` headers, default browser/curl/HttpClient behavior, RFC 7231 media-type matching*

Bad prerequisites (too vague): "Spring MVC", "Jackson", "Java generics".

**Hold all of this in your working memory. Do NOT create the alignment doc yet.**

Briefly tell the user what you found: how many items, what their titles are, and that you're about to probe basics before writing anything. One short paragraph — not a checklist. The full checklist is a Phase B artefact.

#### Step 2 — Probe basics with `AskUserQuestion` (one prerequisite per ask)

Walk the user through the prerequisites — one item at a time, one prerequisite at a time. Tell the user up front that this is the preflight basics phase and the doc will get written after.

**Use the `AskUserQuestion` tool for every basics probe** — not open-ended chat questions. Humans navigate structured options faster than free-text, and bundling sub-aspects into prose inevitably becomes "3 questions disguised as 1".

For each prerequisite of the current item, present a single `AskUserQuestion` with these options:

```
Question: "Point N rests on [PREREQUISITE]. Where are you on this?"
Header: "Prereq N.k"
Options:
  - label: "I know it"
    description: "Skip the teaching — move to the next prerequisite"
  - label: "Teach me"
    description: "5–15 line walk-through with concrete examples from the PR"
  - label: "Partially — refresh me"
    description: "2-line refresher then confirm"
```

The `AskUserQuestion` tool auto-adds an "Other" option for cases the user wants to express themselves.

Based on response:

| User selection | Action |
|---|---|
| "I know it" | Note (in working memory) as `known`; immediately ask the next prerequisite via another `AskUserQuestion` |
| "Teach me" | Teach in chat (5–15 lines, concrete examples from the source artefact). Then issue a follow-up `AskUserQuestion` with options "Got it" / "Still fuzzy — go deeper". Note as `taught` once confirmed; capture a one-paragraph summary for the doc |
| "Partially — refresh me" | Give a 2-line refresher in chat. Then issue a follow-up `AskUserQuestion` with options "Got it now" / "Still fuzzy". Note as `refreshed` once confirmed |
| "Other" | Read the user's free-text response. Adapt — they may have a question, a correction, or want to scope-out the prerequisite |

**Hard rules during the basics probe:**

- **One prerequisite per `AskUserQuestion` call.** Never bundle.
- **A prerequisite is a single concept.** "Accept: */* semantics" is one prerequisite. "Accept: */* semantics AND RFC 7231 media-type ranking AND content negotiation defaults" is THREE prerequisites — split them.
- One **item** at a time too — finish all of Point N's prerequisites before moving to Point N+1.
- Concrete over abstract. Use actual class names, annotations, line numbers from the source artefact in both the question and the teaching.
- If a prerequisite needs its own sub-prerequisite, surface that as a separate `AskUserQuestion` (recurse max 2 levels deep).
- Skip prerequisites the user has already demonstrated understanding of from earlier items.
- **After each item's prerequisites are covered, do not present the claim yet.** Move to the next item's basics. The claims come in Phase B.

**User can short-circuit Phase A.** If the user picks "Other" and says *"skip the basics, just write the doc"* or *"I know enough, let's go"*, honor the override and jump to Phase B — but note which items had their basics check skipped, so the resulting doc can mark those items honestly.

#### Step 3 — Phase A wrap-up

After all items' prerequisites have been probed, briefly summarize the basics outcome in chat:

> *"Phase A done. Across the N items: \[count\] prereqs were already known, \[count\] we walked through. About to write the alignment HTML now — it'll capture what we covered so future-you (and anyone else reading) can see the foundation we built. From here on, the HTML is the living doc — I'll update it as we walk claims."*

Then move to Phase B.

---

### Phase B — Write the alignment artefacts and walk through claims

#### Step 4 — Create the alignment HTML (the primary artefact)

Now that Phase A has surfaced what the user knows / what was taught, create the HTML file directly:

- `docs/<slug>-alignment.html` — **primary living artefact, the source of state.** Updated turn-by-turn for the rest of the session.

**Do NOT create a parallel `.md` file as a "source of truth" any more.** The HTML IS the source. If a markdown audit-trail is wanted later (e.g., for git diff purposes), generate it on-demand FROM the HTML at session end — but Phase B's working document is HTML-only.

The HTML reflects what happened in Phase A. Each item lists its claim and notes basics status compactly via colored badges:

- `(known)` — green badge — prerequisite the user already understood; no Q&A entry needed
- `(taught)` — yellow badge — prerequisite we walked through; teaching summarised in the Q&A section
- `(skipped)` — grey badge — Phase A was short-circuited for this item

**Apply the patterns from [Anthropic's "Unreasonable effectiveness of HTML" post](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html):**

| Blog principle | Concrete pattern for alignment docs |
|---|---|
| Information density > paragraphs | Use tables for any structural comparison (before/after, item × prereq matrix, claim × verdict) |
| Color-coded severity | Pills for status (`In progress` yellow / `Aligned` green / `Blocked` red), badges for prereq state, callouts for "why this matters" |
| Visual navigation > linear scrolling | Checklist cards at top + Q&A log below; section headers act as in-page anchors |
| Interactive where it helps | Optional: click-to-expand item bodies, "Copy as PR comment" button at the bottom that exports a markdown summary the user can paste into the PR thread |
| Side-by-side comparison | Two-column / `<table>` layout for before/after, alternatives considered, or version diffs |
| SVG for diagrams | Use when explaining layered architectures (e.g., the orchestrator → converter → mapper layer cake from the basics phase) |
| Export button keeps human in loop | A "Copy summary" button generating a markdown digest of `[x]` items + open waivers, paste-able into a PR comment |

**HTML skeleton (the established project token system from `html-it` skill):**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Alignment: <Topic></title>
  <style>
    :root {
      --bg: #fafaf7; --fg: #1f2328; --muted: #6e7681; --border: #d0d7de;
      --accent: #0969da; --ok: #1a7f37; --ok-tint: #dafbe1;
      --warn: #bf8700; --warn-tint: #fff5d6;
      --bad: #cf222e; --bad-tint: #fff1f0;
      --code-bg: #eef1f4; --card: #ffffff;
    }
    /* body, headings, code, table, .card, .callout, .pill, .checklist,
       .basics-row .badge, .qa-entry/.qa-q/.qa-a — use the html-it skill's
       full token set; mirror styling from existing alignment HTMLs in docs/ */
  </style>
</head>
<body>
  <h1>Alignment Session: <Topic></h1>
  <div class="meta">
    <div><strong>Source artefact:</strong> <path>
    <div><strong>Started:</strong> YYYY-MM-DD
    <div><strong>Phase A status:</strong> ...
    <div><strong>Primary artefact:</strong> this <code>.html</code> file —
        see <a href="https://claude.com/blog/...">unreasonable effectiveness of HTML</a></div>
    <div><strong>Status:</strong> <span class="pill warn">🟡 In progress</span></div>
  </div>

  <h2>Items under review</h2>
  <ul class="checklist">
    <li>
      <div class="item-title"><Point N> <span class="pill warn|ok|bad">SEVERITY</span> — <claim></div>
      <div><one-line-detail></div>
      <div class="basics-row">
        <span class="badge known|taught|pending">N.k label</span>
        ...
      </div>
    </li>
  </ul>

  <h2>Q&A Log</h2>
  <div class="qa-entry">
    <div class="qa-q">
      <span class="tag">basics|claim|followup</span>
      <span>item-N prereq N.k: <topic></span>
      <span class="date">YYYY-MM-DD</span>
    </div>
    <div class="qa-a"><condensed summary with rich HTML structure></div>
  </div>

  <h2>Decisions / Waivers</h2>
  <!-- Each as a card with .callout.warn or .callout.bad styling -->
</body>
</html>
```

For each Q&A entry, write a **condensed, scannable HTML structure** — not a transcript dump. Use tables when comparing options. Use callouts (`<div class="callout">`) for "why this matters" notes. Use code blocks (`<pre><code>`) for snippets. The Q&A entries are the future-maintainer-friendly record; they should be readable as standalone explanations months later.

**File creation timing:** create the HTML only AFTER Phase A is complete enough that the doc has substantive content. Don't write an empty shell; wait until at least one item's basics have been walked through.

#### Step 5 — Keep the HTML live during Phase B

After every Phase B exchange (claim presented, verdict captured, follow-up answered):

1. **Edit the HTML directly** — update the checklist's item state (`.item.done` for accepted, `.item.waived` for waived), append a new Q&A entry, regenerate the progress counter.
2. Do NOT maintain a parallel markdown file. The HTML is the working doc.
3. If a markdown snapshot is needed at any point (e.g., session-end audit trail), generate it FROM the HTML on demand — but the HTML stays canonical.

#### Step 6 — Present the doc and walk through claims

Tell the user:

- Path to **both** files (markdown + HTML)
- A one-line orientation: "Phase A captured in the doc. Now I'll present each claim one at a time — you accept / waive / push back."

Then walk through items one by one. Per item:

**6a. Present the claim:**

> *"OK — with the foundation we built, here's Point N's claim: \[exact text from the source artefact\]. Reason: \[1–3 sentences\]. Does this hold for you?"*

**6b. Capture the verdict:**

| User response | Action |
|---|---|
| "Got it" / "makes sense" / "fine" | Tick checkbox (`- [x]`); log Q&A as `[claim]`; tell them which item closed |
| "Skip" / "don't care" / "waive" | Mark `- [~]`; log under `## Decisions / Waivers` with the reason |
| Disagrees / pushes back | Do **not** tick. Log under `## Decisions / Waivers`. Propose a revision to either the source artefact OR the item itself. Continue until convergence or explicit waiver. |
| Asks a follow-up question | Answer it. Log as `[followup]`. Loop back into 6a until the claim is accepted, waived, or pushed back. |

**6c. Log and regenerate.**

After each exchange:

1. Append to `## Q&A Log` in the markdown:
   ```
   ### Q (YYYY-MM-DD HH:MM) [claim|followup] item-N: <user question or "claim verdict">
   **A:** <your answer, trimmed>
   ```
2. Regenerate the HTML companion. Never let the two drift.

### Step 7 — Soft check-ins (every 3–4 user turns in Phase B)

After roughly every 3–4 user turns in Phase B, give a **one-paragraph** status:
- ✅ confirmed: <count> — <names>
- 🟡 open: <count> — <names>
- 🚫 waived: <count>

Under 5 lines. It's a summary, not a prompt. Do not append a follow-up question.

### Step 8 — When all boxes resolved

When every item is `[x]` or `[~]`, surface it explicitly:

> All items resolved. Are you aligned, or want to revisit anything?

Then **wait**. Do not declare alignment yourself.

### Step 9 — End the session

User signals alignment with: "aligned", "I'm good", "let's go", "approved", or `/work-towards-alignment done`. On that signal:

1. Update the markdown: `**Status:** 🟢 Aligned` + `**Aligned on:** <YYYY-MM-DD>`.
2. Regenerate the HTML companion with the 🟢 Aligned status pill.
3. Recap what was agreed in chat (under 8 lines).
4. Offer the obvious next step (implement, `/ship`, etc.).

## Special arguments

- `status` → re-read the most recently modified `*-alignment.html` and report current state. No new file.
- `done` → user-initiated termination. Treat as alignment signal.
- `resume <slug>` → reopen a specific alignment HTML file. If found, skip Phase A (basics already covered by definition) and resume Phase B walk-through from wherever it left off.

## Hard rules

- **No Stop hook.** Pace is the user's.
- **Never declare alignment unilaterally.** All boxes ticked is necessary but not sufficient.
- **Never pester.** Silent between turns. Soft check-ins only at the 3–4 turn cadence.
- **Never edit the source artefact unprompted.** If alignment surfaces a needed change, propose it; let the user approve.
- **Phase A precedes file creation.** Do NOT write the alignment HTML until basics have been probed (or the user explicitly says "skip basics, write the doc").
- **HTML is the primary artefact — markdown is at most a frozen snapshot.** Never maintain a parallel `.md` "source of truth". The `.html` IS the source. Per Anthropic's [unreasonable effectiveness of HTML](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html): humans skim rich HTML and bail on long markdown. Alignment sessions accumulate exactly the kind of structured content HTML is best at.
- **Use `AskUserQuestion` for every Phase A basics probe.** Open-ended prose questions invite multi-question bundling — structured options keep one ask = one prerequisite. Mandatory, not optional.
- **One question at a time when clarifying** — don't batch. This applies double during the Phase A basics probe — never ask about multiple prerequisites in one message. If a "prerequisite" turns out to contain sub-concepts, split them into separate prerequisites and issue separate `AskUserQuestion` calls.
- **Never present a claim before basics are confirmed.** Phase A → Phase B ordering is the load-bearing structure of this skill. If the user wants to skip Phase A, they must say so explicitly, and the override gets logged in the HTML as `Phase A skipped at user's request`.
- **Teaching the basics is concise.** 5–15 lines max per prerequisite, with concrete examples drawn from the source artefact. If a prerequisite needs more than that, it probably belongs as its own checklist item.
- **Update the alignment HTML every turn in Phase B** so progress survives session restarts. Edit it directly — don't regenerate from a markdown shadow.
- **Use rich HTML — not "markdown converted to HTML".** Tables for comparisons, badges for status, callouts for warnings, pills for severity. The point of choosing HTML is to USE its visual vocabulary, not to embed markdown inside `<p>` tags.
