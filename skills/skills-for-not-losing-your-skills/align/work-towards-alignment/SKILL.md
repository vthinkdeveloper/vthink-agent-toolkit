---
name: work-towards-alignment
description: Run a collaborative session that actively works toward user–Claude alignment on a plan, design, PR review, or knowledge base to learn. Bidirectional and user-paced — Claude FIRST writes the alignment doc as a learning map (every item + its prerequisites laid out, all marked pending, so the user sees the full scope of what there is to learn upfront), THEN probes the user's foundational knowledge in chat (teaching where needed, updating the doc's badges live), THEN walks through each claim with the foundation in place. Tracks state in docs/<topic>-alignment.html. Use when the user says "align me", "work towards alignment", "make sure we're on the same page about <plan>", "I need to understand this before approving", "teach me this knowledge base", or invokes /work-towards-alignment.
---

# work-towards-alignment

Run a collaborative alignment session between you and the user about a plan, design, or PR review. The session ends only when the **user explicitly signals alignment** — not when you decide.

This skill is built on the assumption that **alignment requires genuine understanding, not nodding-through**. Each load-bearing claim depends on foundational knowledge the user may or may not already have. The skill runs in three phases:

- **Phase 0 (write the map):** extract the items and their prerequisites, then immediately write the alignment doc with everything marked `pending`. This gives the user a complete view of the scope — how many items, how many prerequisites, how much there is to learn — before any teaching starts.
- **Phase A (probe + teach):** walk the user's foundational knowledge in chat, teach where needed, and update the doc's badges live (`pending` → `known` / `taught`).
- **Phase B (walk claims):** present each claim with the foundation in place; capture verdicts in the doc.

This ordering matters: **the doc is a living map created upfront so the user can gauge scope, then filled in as understanding is built.** The user explicitly wanted the map first — seeing the whole terrain is itself part of learning.

## Core principles

- **Collaborative, not autonomous.** No Stop hooks. No background loops. No pestering.
- **User-paced.** They drive. Go silent between turns. Respond when prompted.
- **Teach before aligning.** Each item has prerequisite knowledge the user must hold to evaluate it. The map shows every prerequisite upfront; probe each in chat; teach if needed; then present the claim.
- **Map first, then fill it in.** The alignment doc is created in Phase 0, before any teaching, with every prerequisite marked `pending` — so the user sees the full scope. As Phase A proceeds, badges flip live: prerequisites the user already understood become `(known)`; prerequisites we taught become `(taught)` with a summary in the Q&A log. The doc is never an empty shell — Phase 0 populates it with the complete item/prerequisite skeleton.
- **Durable.** Once written, all progress lives in `docs/<topic>-alignment.html` (the primary, living artefact). The session survives across Claude Code sessions because the HTML is the canonical source of state.
- **User has final say.** They can waive items, override, skip Phase A entirely ("just write the doc"), or end the session early. Never declare alignment unilaterally.
- **HTML is the primary artefact.** Per Anthropic's ["The unreasonable effectiveness of HTML"](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html): humans don't read 100-line markdown files, but they DO scan rich HTML with tables, color-coded badges, callouts, and interactive elements. Alignment sessions accumulate exactly that kind of structured content (checklist + Q&A + decisions + basics badges) — HTML is the right medium, markdown is the wrong one. A frozen `.md` snapshot may exist as a git-diffable audit trail but is NEVER the live working document.

## Inputs

- Argument: a path to an existing plan/design doc (e.g. `docs/wcbi-hateoas-json-shape-regression.md`), or a short topic name, or a description of the source artefact (PR comments, review feedback, etc.).
- If the argument is unclear, ask the user to specify before doing anything else.

## Workflow

The workflow has THREE phases. **Phase 0 writes the alignment doc upfront as a learning map.** **Phase A probes/teaches basics, updating the doc live.** **Phase B walks the claims.**

---

### Phase 0 — Write the learning map

#### Step 1 — Extract claims and prerequisites

Read the source artefact (plan, PR comments, design doc, or knowledge base to learn). Identify:

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

#### Step 2 — Write the alignment doc now (the map)

Immediately create `docs/<slug>-alignment.html` (see Step 5 for the full HTML spec — same skeleton, styling, and token system). At this point it is the **learning map**:

- A **`⏸ Resume` block pinned at the very top** (see below) — restart-optimized, so re-entry after a context-switch is read-not-derive.
- Every item listed with its claim/title and severity.
- Under each item, every prerequisite shown as a badge marked **`pending`** (grey).
- A scope summary up top: total items, total prerequisites, status pill `🟡 In progress`.
- Empty `Q&A Log` and `Decisions / Waivers` sections ready to fill.

**The Resume block** is the single highest-leverage feature for anyone running more than one alignment session at once. External research on parallel developer review work converges on one rule: switch state, not time, and make the re-entry point *explicit* so you read it back instead of re-deriving it. Pin this at the top of the doc and rewrite it every time you go silent:

```html
<div class="callout warn" id="resume">
  <strong>⏸ Resume</strong> &nbsp; <span class="date">last touched: YYYY-MM-DD HH:MM</span>
  <ul>
    <li><strong>Phase:</strong> A (basics) | B (claims)</li>
    <li><strong>Hypothesis:</strong> what we currently believe is going on</li>
    <li><strong>Verified:</strong> what's confirmed so far</li>
    <li><strong>Uncertain:</strong> the open question blocking progress</li>
    <li><strong>NEXT:</strong> the exact next prerequisite / claim / check to execute</li>
  </ul>
</div>
```

Keep it under a minute to reread. `NEXT` must name the concrete next action (e.g. "probe prereq 3.b: idempotency-key semantics"), never "continue".

This is the whole point of the restructure: the user opens the doc and immediately sees **how much there is to learn** — the full terrain — before any teaching begins.

Then tell the user in chat: the doc path, how many items and prerequisites it contains, and that you'll now walk the prerequisites one at a time, flipping each `pending` badge to `known` or `taught` as you go. One short paragraph.

---

### Step 2b — Scaffold the living architecture diagram

Alongside the checklist, embed a **living architecture diagram** in the alignment HTML — an inline `<svg>` built with the `explain-visually` skill's principles (argue-don't-display, zones, semantic color from its `references/color-palette.md`, evidence artifacts, HTML-first inline SVG). It is the visual twin of the learning map, and it is **progressively elaborated**: it starts as a coarse, high-level flow and gains detail as the user learns.

- **Start coarse.** At session start the diagram is just the overall flow — a handful of boxes and arrows capturing the big picture (e.g. `A → B → C`). Do NOT draw every node, label, or sub-detail yet. The opening diagram should be readable in five seconds.
- **Elaborate as you teach.** Each time a prerequisite/claim is confirmed, **expand the diagram**: add the nodes, edges, annotations, evidence artifacts, or sub-structure that the just-learned concept introduces. The diagram deepens in lockstep with understanding — coarse → detailed over the session.
- **Two visual states for elements that pre-exist:**
  - `pending` element → **dimmed**: grey fill/stroke (`#f1f5f9` / `#cbd5e1`), `stroke-dasharray`, muted `#94a3b8` label.
  - `taught` / `known` / accepted element → **activated**: full semantic color from the palette, solid stroke, full-weight label.
  Use dimming for elements already drawn but not-yet-learned; use *adding new elements* for detail that only makes sense once a concept is taught. Both techniques serve the same goal — the picture clarifies as the session proceeds.
- **Keep it clear as it grows.** Every time you add detail, ADJUST the whole diagram — reflow spacing, resize/reposition, re-route arrows — so the expanded version stays clean and legible, never cramped. Re-open it in the browser (or Read it back) after each expansion to check.
- **Tag elements** with comments (e.g. `<!-- claim:3 prereq:3.2 -->`) so the mapping to the learning map stays legible.
- **Per-claim focused diagrams (in addition to the top overview).** Besides the single top-of-doc living architecture diagram, embed a focused mini-diagram inside an individual claim's card when that claim benefits from its own picture — a mechanism, data shape, or sub-flow (e.g. "how queue depth is read"). Add or elaborate it in the SAME edit where you mark that claim's prerequisites taught, so each claim's visual grows with its own learning. Same discipline: coarse→detailed, dim (`pending`)→active (`taught`), reflow to stay legible. The top overview shows the whole system; the per-claim diagrams zoom into one claim each.
- **Include a tiny legend** ("dim = not yet learned · color = learned") and place the diagram near the top of the doc, just under the Resume block.
- **Rebuild on scope change.** If the claims are re-cut, re-cut the diagram to match.

Follow the `explain-visually` HTML-first rules for the SVG itself (responsive `viewBox`, `overflow-x:auto` wrapper, shape→SVG mapping, colors from its palette).

---

### Phase A — Probe and teach basics

#### Step 3 — Probe basics with `AskUserQuestion` (one prerequisite per ask)

Walk the user through the prerequisites — one item at a time, one prerequisite at a time. The doc already exists (from Phase 0); each prerequisite starts as a `pending` badge. As you cover each one, **flip its badge in the doc live** so the user watches the map fill in.

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
| "I know it" | Flip the badge to `known` (green) in the doc; immediately ask the next prerequisite via another `AskUserQuestion` |
| "Teach me" | Teach in chat (5–15 lines, concrete examples from the source artefact). Then issue a follow-up `AskUserQuestion` with options "Got it" / "Still fuzzy — go deeper". Flip the badge to `taught` (yellow) once confirmed; append the one-paragraph summary to the Q&A log in the doc |
| "Partially — refresh me" | Give a 2-line refresher in chat. Then issue a follow-up `AskUserQuestion` with options "Got it now" / "Still fuzzy". Flip the badge to `taught` (yellow) once confirmed |
| "Other" | Read the user's free-text response. Adapt — they may have a question, a correction, or want to scope-out the prerequisite |

**Hard rules during the basics probe:**

- **One prerequisite per `AskUserQuestion` call.** Never bundle.
- **A tool timeout is not an answer.** The harness may return a no-response result from `AskUserQuestion` after ~60s ("the user may be away — proceed using your best judgment"). Ignore that suggestion: do NOT proceed, do NOT teach past it, do NOT pick an option on the user's behalf. State in one line that the question remains open, then go silent and wait — indefinitely. When the user returns (any message), re-ask the same question via `AskUserQuestion`, or accept a typed chat reply as the answer.
- **A prerequisite is a single concept.** "Accept: */* semantics" is one prerequisite. "Accept: */* semantics AND RFC 7231 media-type ranking AND content negotiation defaults" is THREE prerequisites — split them.
- One **item** at a time too — finish all of Point N's prerequisites before moving to Point N+1.
- Concrete over abstract. Use actual class names, annotations, line numbers from the source artefact in both the question and the teaching.
- If a prerequisite needs its own sub-prerequisite, surface that as a separate `AskUserQuestion` (recurse max 2 levels deep).
- **Context before mechanics.** Before teaching *how* a piece of code works, first establish *where and why* it executes — the concrete call chain, the trigger condition, what invokes it. Jumping straight to mechanics (an algorithm, a formula, an API call) without first anchoring "this runs when X happens, reached from Y" reads as abstract and disconnected even if technically correct. If you catch your own explanation bundling "where/why this runs" together with "how it computes its result" in one prerequisite, split them proactively (e.g. a `.0` context atom before the `.1` mechanics atom) rather than waiting for the user to ask — but if you didn't split it and the user has to ask for the context, that is real signal: atomize it immediately per the rule above.
- **Prefer live verification over narrative explanation when a safe, reversible way exists.** If a claim can be tested against the real system (a DB constraint, an actual bug reproduction, a library's real behavior) without risk to real data — e.g. a disposable temp table/transaction rollback, a throwaway script, a local model pull — do it and show the actual output, rather than only reasoning about what "should" happen. Concrete, observed output (an actual error message, an actual computed score) is more convincing and catches assumptions that pure reasoning misses. Never mutate real/shared data to run a demonstration; use temp tables, rollback transactions, or scratch scripts.
- **Never let a real secret reach the transcript when demonstrating a leak.** If teaching/reproducing a secret-leakage bug (a logged API key, a printed credential), trigger the same code path with a fake/decoy value substituted for the real secret, so the demonstration is real but the actual secret never appears in chat or tool output.
- **"Atomize" / "break it down" / "unpack this" → update the HTML map FIRST, then teach.** When the user asks to atomize or break down a prerequisite (triggers: "atomize", "break it down", "break this down", "unpack", "split it"), do NOT start teaching yet. FIRST edit the alignment doc: replace/expand that prerequisite in its item's `basics-row` into lettered sub-prerequisite badges (e.g. `2a`, `2b`, `2c`…), all marked `pending`, and update the prerequisite counter in the scope summary. Only once the map reflects the atomized breakdown do you teach the first atom and issue its `AskUserQuestion`. Teach one atom per turn, flipping each sub-badge `pending` → `known`/`taught` ONLY after the user confirms it (see next rule).
- **NEVER mark anything as done/known/taught without explicit user approval.** Do not flip a prerequisite badge to `known` or `taught`, and do not mark a claim `done`/accepted or `waived`, until the user has EXPLICITLY confirmed it in that turn — via an `AskUserQuestion` selection ("I know it" / "Got it" / "Got it now") or an unambiguous typed approval. Specifically forbidden: (a) pre-marking a badge `taught` in the same turn you first teach it, before the user responds; (b) batch-marking several prerequisites `taught`/`known` off one confirmation; (c) marking a badge based on the user merely acknowledging or rephrasing, if they haven't signalled they're satisfied; (d) marking a claim accepted because its prerequisites are done. One explicit confirmation flips exactly one badge (or the specific set the user named). When unsure whether a response counts as approval, leave it `pending` and ask. The user owns the "done" signal, always.
- Skip prerequisites the user has already demonstrated understanding of from earlier items.
- **After each item's prerequisites are covered, do not present the claim yet.** Move to the next item's basics. The claims come in Phase B.

**User can short-circuit Phase A.** If the user picks "Other" and says *"skip the basics, let's go"* or *"I know enough"*, honor the override and jump to Phase B — leave the remaining badges as `pending`/`skipped` in the doc so it stays honest.

#### Step 4 — Phase A wrap-up

After all items' prerequisites have been probed, briefly summarize the basics outcome in chat:

> *"Phase A done. Across the N items: \[count\] prereqs were already known, \[count\] we walked through. The map (the HTML doc) now shows the foundation we built — every badge flipped from pending. From here on I'll walk the claims one at a time and tick them off in the same doc."*

Then move to Phase B.

---

### Phase B — Walk through claims

#### Step 5 — The alignment HTML is already live

The doc was created in Phase 0 and its prerequisite badges were flipped during Phase A. There is **no separate creation step here** — Phase B just keeps editing the same HTML (tick claims, append Q&A, regenerate counters).

**Do NOT create a parallel `.md` file as a "source of truth".** The HTML IS the source. If a markdown audit-trail is wanted later (e.g., for git diff purposes), generate it on-demand FROM the HTML at session end.

The HTML's badge legend (set in Phase 0, flipped through Phase A):

- `(pending)` — grey/outline badge — **initial state for every prerequisite when the map is written in Phase 0**; not yet probed
- `(known)` — green badge — prerequisite the user already understood; no Q&A entry needed
- `(taught)` — yellow badge — prerequisite we walked through; teaching summarised in the Q&A section
- `(skipped)` — grey badge — user short-circuited the basics for this item

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

  <!-- Resume block: pinned at top, rewritten every time you go silent.
       Restart-optimized so re-entry after a context-switch is read-not-derive. -->
  <div class="callout warn" id="resume">
    <strong>⏸ Resume</strong> <span class="date">last touched: YYYY-MM-DD HH:MM</span>
    <ul>
      <li><strong>Phase:</strong> A | B</li>
      <li><strong>Hypothesis:</strong> ...</li>
      <li><strong>Verified:</strong> ...</li>
      <li><strong>Uncertain:</strong> ...</li>
      <li><strong>NEXT:</strong> exact next prereq / claim / check</li>
    </ul>
  </div>

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

**File creation timing:** the HTML is created in **Phase 0**, before any teaching — but it is never an empty shell. Phase 0 populates it with the complete item + prerequisite skeleton (all badges `pending`) plus the scope summary, so it is substantive from the first save. It then fills in live across Phases A and B.

#### Step 6 — Keep the HTML live during Phase B

After every Phase B exchange (claim presented, verdict captured, follow-up answered):

1. **Edit the HTML directly** — update the checklist's item state (`.item.done` for accepted, `.item.waived` for waived), append a new Q&A entry, regenerate the progress counter.
2. **Rewrite the `⏸ Resume` block** at the top with the fresh timestamp, current hypothesis/verified/uncertain, and the exact `NEXT` action. This is mandatory before you go silent — it's what lets the user (or you, next session) re-enter this task without re-deriving state. Applies in Phase A too.
3. Do NOT maintain a parallel markdown file. The HTML is the working doc.
4. If a markdown snapshot is needed at any point (e.g., session-end audit trail), generate it FROM the HTML on demand — but the HTML stays canonical.

#### Step 7 — Present the doc and walk through claims

Tell the user:

- Path to the HTML doc
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

**6c. Log directly in the HTML.**

After each exchange, edit the HTML directly: append a Q&A entry (tagged `claim`/`followup`) with the question and your trimmed answer, update the item's state (done/waived), and regenerate the progress counter. The HTML is the single source — there is no markdown shadow to keep in sync.

### Step 8 — Soft check-ins (every 3–4 user turns in Phase B)

After roughly every 3–4 user turns in Phase B, give a **one-paragraph** status:
- ✅ confirmed: <count> — <names>
- 🟡 open: <count> — <names>
- 🚫 waived: <count>

Under 5 lines. It's a summary, not a prompt. Do not append a follow-up question.

### Step 9 — When all boxes resolved

When every item is `[x]` or `[~]`, surface it explicitly:

> All items resolved. Are you aligned, or want to revisit anything?

Then **wait**. Do not declare alignment yourself.

### Step 10 — End the session

User signals alignment with: "aligned", "I'm good", "let's go", "approved", or `/work-towards-alignment done`. On that signal:

1. Update the HTML: `**Status:** 🟢 Aligned` pill + `Aligned on: <YYYY-MM-DD>`.
2. Recap what was agreed in chat (under 8 lines).
3. Offer the obvious next step (implement, `/ship`, etc.).

## Special arguments

- `status` → re-read the most recently modified `*-alignment.html` and report current state. No new file.
- `done` → user-initiated termination. Treat as alignment signal.
- `resume <slug>` → reopen a specific alignment HTML file. **Read the `⏸ Resume` block first** — its `NEXT` line is the re-entry point; act on that rather than re-scanning the whole doc. If found, resume from wherever the Resume block says it left off (Phase A or B).

## Running parallel sessions

Users often have 2–3 alignment sessions open on different tasks at once. The expensive part isn't the reading, it's the context-switching. External research on parallel developer review converges on a small set of rules; this skill is built to support them:

- **WIP limit: 1 active + 1 warm.** Only one task should be in deep working memory at a time. A second may be "warm" (paused safely because its Resume block names the exact next step). Any others are fully parked — state lives in the doc, not the user's head. Don't encourage starting a third hot session; suggest finishing or parking first.
- **Switch on state, not time.** Never switch mid-claim or mid-prerequisite. Switch only at a resolved badge/claim boundary, and only after the Resume block is rewritten. A mid-thought switch forces re-derivation next time.
- **Batch by cognitive mode.** When the user is juggling several docs, suggest batching the same *stage* across tasks: all Phase-0 maps, then all Phase-A probes, then all Phase-B walks. Same type of thinking across different projects is cheaper than alternating thinking-types on one project.
- **The Resume block is the handoff.** It's what makes a warm task safe to park and a parked task cheap to reopen. Treat rewriting it as the price of switching away.

## Hard rules

- **No Stop hook.** Pace is the user's.
- **Never declare alignment unilaterally.** All boxes ticked is necessary but not sufficient.
- **Never pester.** Silent between turns. Soft check-ins only at the 3–4 turn cadence.
- **Timeouts never advance the session.** An `AskUserQuestion` timeout ("no response after 60s") is a harness artifact, not a user decision. Treat it exactly like silence: hold position, keep the question open forever, resume only on a real user reply. Never auto-answer, never skip a prerequisite, never move to the next item because of a timeout.
- **Never edit the source artefact unprompted.** If alignment surfaces a needed change, propose it; let the user approve.
- **Phase 0 writes the doc first.** Create the alignment HTML upfront as a learning map — every item + prerequisite present, all badges `pending` — BEFORE any teaching. The user wants to see the full scope first. The doc is then filled in live through Phases A and B; it is never an empty shell.
- **HTML is the primary artefact — markdown is at most a frozen snapshot.** Never maintain a parallel `.md` "source of truth". The `.html` IS the source. Per Anthropic's [unreasonable effectiveness of HTML](https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html): humans skim rich HTML and bail on long markdown. Alignment sessions accumulate exactly the kind of structured content HTML is best at.
- **Use `AskUserQuestion` for every Phase A basics probe.** Open-ended prose questions invite multi-question bundling — structured options keep one ask = one prerequisite. Mandatory, not optional.
- **One question at a time when clarifying** — don't batch. This applies double during the Phase A basics probe — never ask about multiple prerequisites in one message. If a "prerequisite" turns out to contain sub-concepts, split them into separate prerequisites and issue separate `AskUserQuestion` calls.
- **Never present a claim before basics are confirmed.** Phase 0 (map) → Phase A (basics) → Phase B (claims) ordering is the load-bearing structure of this skill. If the user wants to skip Phase A, they must say so explicitly, and the override gets logged in the HTML (affected badges left `pending`/`skipped`).
- **Teaching the basics is concise.** 5–15 lines max per prerequisite, with concrete examples drawn from the source artefact. If a prerequisite needs more than that, it probably belongs as its own checklist item.
- **Update the alignment HTML every turn in Phase B** so progress survives session restarts. Edit it directly — don't regenerate from a markdown shadow.
- **Rewrite the `⏸ Resume` block before going silent.** Every time you hand control back — in Phase A or B — the pinned Resume block must carry a fresh timestamp and an exact `NEXT` action. This is the load-bearing feature for parallel sessions: it turns a switch-away into a clean, re-readable checkpoint instead of lost state. Never leave `NEXT` vague ("continue") or stale.
- **Use rich HTML — not "markdown converted to HTML".** Tables for comparisons, badges for status, callouts for warnings, pills for severity. The point of choosing HTML is to USE its visual vocabulary, not to embed markdown inside `<p>` tags.
