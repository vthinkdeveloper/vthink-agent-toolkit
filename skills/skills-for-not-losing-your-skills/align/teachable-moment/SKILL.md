---
name: teachable-moment
description: >
  When a design decision or unfamiliar concept surfaces while implementing something, turn it into
  a short, durable learning session that makes the user a better engineer over the long term. It
  FIRST gauges what the user already knows and asks them to commit a prediction (what they'd choose
  and why) BEFORE any teaching — struggling before the reveal is what makes it stick. Then it grounds
  WHAT to teach in industry consensus: it names the general concept and produces an ANONYMIZED research
  prompt the user pastes into an external AI to fetch the standard industry terminology, the canonical
  option space, and the sub-concepts a strong SWE should know (anonymize is just the safety gate that
  lets us use an external AI, not the goal). It then teaches a tight concept card (real options + the
  1-2 most confusable distractors, a decision rule, the rule applied back, common traps), grills the user 2-3
  questions ONE at a time with a "why is that right / why not the other?" self-explanation follow-up,
  and saves a self-contained HTML concept card WITH A DUE-DATE to /Users/adharshdhandapani/git/learning-from-experience/ (a personal
  cross-project learnings repo). Spaced re-review of saved cards is a SEPARATE skill (review-learnings)
  the user runs when they have time — this skill only creates cards. Deliberately short (~10-15 min,
  one concept). Invoke with /teachable-moment [optional: the decision/concept], or when the user says
  "teach me the concept behind this", "that was a teachable moment", "grill me on this concept",
  "what are my real options here", or "make this a learning moment".
---

# teachable-moment

Turn one concrete implementation decision into one short, durable lesson on the **general** concept
behind it. Goal = transfer: the user leaves able to apply the idea on a different problem in a
different codebase, and to make the call *intuitively* over time — not just recall today's choice.

**Keep it SHORT** — ~10-15 minutes, ONE concept. If you're teaching three concepts, scope is too big;
pick the single most load-bearing one and offer the rest as follow-up cards.

**Scope to the work at hand.** Teach only what's directly relevant to unblocking or understanding the
CURRENT decision. When adjacent or "nice to know" concepts surface, do NOT chase them — **backlog**
them (Step 5) to learn later. Relevance to today's work beats completeness, every time.

**Design principle baked in:** this workflow front-loads *retrieval before reveal* and ends with a
*durable, re-reviewable card*. Passive reading feels like learning but barely is — so the user must
predict before being taught, and explain their reasoning after each answer.

## Workflow

### Step 1 — Gauge + predict (BEFORE any teaching)

Do this first, always. It is the highest-leverage step and the user explicitly wants it.

1. Name the decision in one line and identify the general concept behind it (see Step 2's anonymize
   technique to find the concept).
2. Ask the user, via `AskUserQuestion`, to **commit a prediction before seeing anything**:
   "Before I teach anything — what would YOU choose here, and what's the single biggest trade-off
   driving it?" Offer 2-3 plausible stances plus their own via "Other". Also gauge depth: are they
   at "never seen this", "seen it, fuzzy", or "confident"?
3. Use their answer to calibrate: skip what they clearly know, go deeper where they're fuzzy or
   guessed wrong. A wrong prediction is GOOD — it primes them to actually absorb the reveal.

Never skip straight to teaching. The struggle is the point.

### Step 2 — Get industry-grounded input on WHAT to teach (external paste loop)

The point of this step is **curriculum, not privacy**: ground the lesson in industry-standard
terminology, the canonical option space, and the sub-concepts a strong SWE is expected to know —
rather than only what Claude happens to recall. Anonymizing is just the **safety gate** that lets us
use an external AI at all.

1. Name the concept in 2-6 words (e.g. "Configuration storage strategy"), derived from the decision;
   confirm it with the user in one line.
2. Produce an **anonymized research prompt** (use the anonymize-prompt skill / its technique — strip
   ALL class/table/column/service/business names) that asks an external AI for:
   - the standard **industry name(s)** for this concept;
   - the **canonical full option space**, with correct terminology (so we catch anything Claude
     missed or mislabeled);
   - the **sub-concepts / trade-off axes** a strong SWE should understand here;
   - **best practices** and the most common **pitfalls**;
   - the best **industry-leading sources** for deeper study — engineering blogs from top firms
     (e.g. the recognized leaders in the relevant domain), write-ups/talks by acknowledged experts,
     and canonical books / papers / official docs. Explicitly ask for HIGH-SIGNAL, authoritative
     sources, not random blogspam or SEO content.
   Copy it to the clipboard (`pbcopy`) and tell the user to paste it into their preferred external AI
   (Gemini / ChatGPT / Perplexity) and paste the answer back.
3. **Wait for the pasted response.** Teach (Step 3) FROM it: adopt the industry terminology it
   surfaces and reconcile it with Claude's own knowledge — explicitly flag any disagreement rather
   than silently picking a side. **BUT restrict the teaching to the part relevant to the current work
   decision.** The external answer will come back broad (full option space + adjacent concepts); that
   breadth informs the saved CARD as reference and feeds `BACKLOG.md` — it does NOT expand what you
   teach live. Teach the work-relevant core; backlog the rest.
4. This step is **NOT optional and you do NOT ask the user whether to run it** — always produce the
   anonymized prompt and run the paste-loop. (Only if the user explicitly insists on skipping mid-run
   do you fall back to Claude's own knowledge, and then mark the card "not externally validated".)

(This paste round-trip is the one accepted exception to "keep it short" — the user opted into it
because industry-correct terminology and a complete option space are worth the detour.)

### Step 3 — Teach CORE-FIRST (align-style: load-bearing claims before the periphery)

**Do NOT dump the whole concept at once** — a wall of options + axes + adjacent concepts is cognitive
overload and the main failure mode this step guards against. Teach in two passes, and confirm the core
lands before adding anything.

**3a. Core — the load-bearing claims.** Distill the concept to the **1-2 ideas everything else hangs
on** — the claims that, once understood, make the rest *derivable*. Teach ONLY these first, tightly,
with one concrete example each. Then **check they landed** (an open-ended "so why would X go where?"
or a quick restate-it-back) BEFORE introducing anything else. Example — for config placement the core
is: (i) *a value's home is dictated by its change-rate + owner + sensitivity*; (ii) *real systems
LAYER homes with a precedence order*. The 11-row option table and the 12 axes are derivable from those
two — so they are NOT core.

**3b. Expand — only after the core lands, and only as far as time/appetite allow.** Now add: the
grounded example (their real decision, contrasted with their Step-1 prediction), the **1-2 most
confusable distractors** (not the full catalog), and the **top 2-3 traps**. The LONG TAIL —
exhaustive option lists, every axis, adjacent concepts — goes into the saved CARD as reference and/or
becomes FUTURE cards. Do not teach it all live; **explicitly name what you're deferring** so it's a
conscious choice, not a silent omission.

One `★ ... ─` insight box for the single biggest takeaway. Bullets, not essays. No lecturing.

(The saved card in Step 5 may still hold the fuller option space as a *reference* — a card is a
lookup doc. The rule here is about the LIVE TEACHING: lead with the core, defer the rest.)

### Step 4 — Grill (2-3 questions, transfer + self-explanation)

- **ONE question per turn**, asked **OPEN-ENDED in chat** (explain / why / what-breaks-if /
  spot-the-flaw) — the user answers in prose. Do NOT use multiple-choice / `AskUserQuestion` for grill
  questions; MCQ only rarely as a deliberate change of pace. Prose recall is harder (better) retrieval
  than recognizing an option. Never batch. Most important rule.
- **2-3 questions only** (protect the budget): at least one is a NEW scenario in a *different domain*
  (far transfer, not recall); include one "spot the anti-pattern" or "what breaks if…".
- **After each answer, a self-explanation follow-up:** "what cue made that the right pick, and what
  would've made the other option better?" This is where shallow recognition gets exposed. Grade in
  one line, correct gaps in 2-4 lines, teach on every wrong/fuzzy answer.
- Track solid vs shaky sub-points for the scorecard. If they're acing it, stop early.

### Step 5 — Save the card + due-date + log row

Write a self-contained HTML concept card to `/Users/adharshdhandapani/git/learning-from-experience/cards/<concept-slug>.html`. Use the `html-it` token system (same `:root` vars, `.card`, `.callout`, `.pill`, tables).
Keep it rereadable in ~2 minutes. Card contents, in order:

- Title (concept name) + one-line generalized definition + date.
- The trimmed option-space table.
- The decision rule (callout).
- "Where I met this" — one line naming the original real decision (the only repo-specific bit).
- Common traps.
- **Scorecard** — solid vs shaky sub-points, auto-generated from the Step-4 answers (do NOT make the
  user write it). Minimal.
- **`data-due` attribute + a visible "Next review" line** — set the first due-date to **+1 day** from
  today (compute with `date -v+1d +%F` on macOS). The review-learnings skill reads this.
- "Related concepts" — plain names, to cross-link future cards.

Then append one row to `/Users/adharshdhandapani/git/learning-from-experience/README.md` (create if missing) — this is the learnings
repo index / experience log:
`| <date> | <what I was working on> | [<Concept>](cards/<slug>.html) | <shaky spots or "—"> | <next-due> | 1 |`
(the repo README already has the header row: Date · Working on · Concept · Shaky spots · Next review · Rung — just append; new cards start at Rung 1).

**Backlog the tangents.** Any adjacent / "worth learning later" concepts that surfaced but you did
NOT teach (because they weren't relevant to today's work) → append one line each to
`/Users/adharshdhandapani/git/learning-from-experience/BACKLOG.md` (create if missing):
`- <concept> — <why it's worth learning> (surfaced <date>, from <work>)`. This captures them so they
aren't lost, without expanding the session. Don't card them, don't teach them — just log.

Commit the new card + README row + any BACKLOG additions to the repo (`git add -A && git commit`) so
the library is versioned.

Finish in chat: card path, scorecard summary (solid vs shaky), next-review date, and a one-line note
that `/review-learnings` will resurface it when due. **Then close by naming the tangential concepts you
backlogged, in one sentence with a pointer** — e.g. *"There are related concepts like X, Y, Z — if you
want to master them later, they're captured in the `learning-from-experience` repo."* Offer to spin
shaky points into a follow-up card or move on.

## Hard rules

- **Predict before teach.** Step 1 (gauge + prediction) always runs first. Never reveal the answer cold.
- **One concept per session.** Narrow ruthlessly; shorter than an alignment session by design.
- **General before specific.** Lead with the transferable idea; the repo is only the grounding example.
- **Always ground the curriculum externally (Step 2) — no asking.** Always run the anonymize/paste
  loop (industry terminology + canonical option space, anonymize as the safety gate); never ask the
  user whether to. When teaching from the external answer, restrict it to the work-relevant concept,
  flag any disagreement with Claude's view, and backlog the adjacent concepts it surfaces.
- **Scope to the work; backlog the rest.** Teach only the concept(s) relevant to the current decision.
  Adjacent concepts go to `BACKLOG.md`, not into the session — capture, don't chase.
- **Core-first (align-style).** Teach the 1-2 load-bearing claims and confirm they land BEFORE any
  periphery; defer the long tail (full option lists, every axis, adjacent concepts) to the card /
  future cards. Never front-load the whole concept — that overload is the failure mode this prevents.
- **Trim the option space** to real options + the 1-2 most confusable distractors — not a catalog.
- **2-3 grill questions, one at a time, OPEN-ENDED (prose, not multiple-choice)**, each with a "why?" self-explanation follow-up; teach on wrong answers.
- **Auto-generate the minimal scorecard**; never turn Step 5 into a note-taking project.
- **Always set a due-date and append the log row** unless the user says chat-only. Spacing itself lives
  in the separate `review-learnings` skill.
- **Guard against illusions of competence:** naming a concept ≠ applying it under pressure. Say so.
- **Never invent options or rules you're unsure of** — keep the card honest over plausible-but-wrong.
