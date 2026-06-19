---
name: work-towards-alignment-simple
description: Markdown-only alignment skill. Two-phase collaborative session — probe foundational knowledge first, then walk claims one by one until the user explicitly signals alignment. All output is plain .md. Invoke with /work-towards-alignment-simple <path-to-plan-or-topic>.
---

# work-towards-alignment-simple

A two-phase collaborative alignment session. User-paced, never declares alignment unilaterally. All output is plain markdown.

## Inputs

- Argument: a path to a plan/design doc, a PR number, or a short topic description.
- If unclear, ask the user to specify before doing anything else.

## Workflow

Two phases. Phase A is chat-only — no files written. Phase B writes one markdown file and walks claims.

---

### Phase A — Chat-only knowledge probe

#### Step 1 — Read and internalize

Read the source artefact. Identify:

- **5–10 load-bearing claims** the user must actively agree with (root causes, decisions, trade-offs, scope boundaries, verification steps).
- **Per-claim prerequisites** — the specific concepts the user must understand to evaluate each claim. Be concrete: name classes, annotations, patterns — not vague terms like "Spring" or "auth".

**Do not write any file yet.** Hold everything in working memory.

Tell the user in one short paragraph: how many items you found, what their titles are, and that you're about to probe basics before writing anything.

#### Step 2 — Probe with AskUserQuestion (one prerequisite at a time)

For each prerequisite, issue one `AskUserQuestion`:

```
Question: "Point N rests on [PREREQUISITE]. Where are you on this?"
Header: "Prereq N.k"
Options:
  - "I know it"         → skip teaching, move on
  - "Teach me"          → 5–15 line explanation with concrete examples
  - "Partially"         → 2-line refresher, then confirm
```

Rules:
- One prerequisite per call. Never bundle.
- Finish all of Point N's prerequisites before moving to Point N+1.
- If the user says "skip basics / just write the doc", honor it and jump to Phase B — log which items had basics skipped.

#### Step 3 — Phase A wrap-up

After all prerequisites are probed, say in chat (one short paragraph):

> "Phase A done. [count] prereqs known, [count] taught. Writing the alignment doc now."

Then move to Phase B.

---

### Phase B — Write the markdown doc and walk claims

#### Step 4 — Create `docs/<slug>-alignment.md`

Write a single markdown file. It reflects what Phase A established.

**Structure:**

```markdown
# Alignment: <Topic>

**Source:** <path or description>
**Started:** YYYY-MM-DD
**Status:** 🟡 In progress

---

## Items

### 1. <Claim title>
**Claim:** <exact claim text>
**Prerequisites:** <prereq> `[known]` | `[taught]` | `[skipped]`

- [ ] Accepted

---

### 2. <Claim title>
...

---

## Q&A Log

### YYYY-MM-DD [basics] item-1, prereq 1.1: <topic>
<teaching summary — 3–8 lines, concrete>

---

## Decisions / Waivers

<!-- waivers and overrides go here -->
```

Badge meanings in the prerequisites line:
- `[known]` — user already understood this; no Q&A entry needed
- `[taught]` — walked through in Phase A; summary in Q&A Log
- `[skipped]` — Phase A was short-circuited for this item

#### Step 5 — Present claims one at a time

After creating the file, tell the user its path and say: "Phase A captured. Walking claims one at a time now — accept, waive, or push back."

Per claim:

> "With the foundation we built — here's Point N's claim: [exact text]. Reason: [1–3 sentences]. Does this hold?"

| User response | Action |
|---|---|
| "Got it" / "fine" | Mark `- [x] Accepted`; append Q&A entry tagged `[claim]` |
| "Skip" / "waive" | Mark `- [~] Waived`; log under Decisions / Waivers |
| Pushes back | Do NOT mark. Log under Decisions / Waivers. Propose revision. Loop until convergence or explicit waiver. |
| Follow-up question | Answer, log as `[followup]`, loop back to presenting the claim |

Update the markdown file after every exchange.

#### Step 6 — Soft check-ins

Every 3–4 turns in Phase B, give a one-paragraph status (no follow-up question):

> ✅ confirmed: N — [names] | 🟡 open: N — [names] | 🚫 waived: N

#### Step 7 — All items resolved

When every item is `[x]` or `[~]`:

> "All items resolved. Are you aligned, or want to revisit anything?"

Wait. Do not declare alignment yourself.

#### Step 8 — End the session

User signals alignment ("aligned", "I'm good", "approved", `/work-towards-alignment-simple done`):

1. Update the doc: `**Status:** 🟢 Aligned` + `**Aligned on:** YYYY-MM-DD`
2. Recap in chat (under 8 lines) what was agreed.
3. Offer the next step (implement, `/ship`, open PR, etc.).

---

## Special arguments

- `status` → re-read the most recently modified `*-alignment.md` and report current state.
- `done` → treat as alignment signal.
- `resume <slug>` → reopen an existing alignment doc. Skip Phase A; resume Phase B from where it left off.

---

## Hard rules

- **No Stop hook.** Pace is the user's.
- **Never declare alignment unilaterally.**
- **Never pester.** Silent between turns; check in only at the 3–4 turn cadence.
- **Never edit the source artefact unprompted.**
- **Phase A before file creation.** Don't write the doc until basics have been probed (or the user explicitly skips Phase A).
- **Update the markdown after every Phase B exchange** so progress survives session restarts.
- **One question at a time.** Never bundle prerequisites or claims.
- **Never present a claim before its basics are confirmed** — unless the user explicitly overrides.
- **Teaching is concise.** 5–15 lines max per prerequisite, with concrete examples from the source artefact.
