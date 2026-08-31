---
name: review-learnings
description: >
  Spaced, interleaved re-review of the concept cards the user has built up in their personal
  learnings repo (/Users/adharshdhandapani/git/learning-from-experience/, created by the teachable-moment skill). The user invokes this
  when they have some free time; it turns the archive of cards into an actual spaced-retrieval system.
  It reads the repo index, pulls the cards that are DUE (by their next-review date) plus interleaves a
  couple from other topics/domains, and for each runs a COLD retrieval — showing only the concept name
  and asking the user to reconstruct the option space, decision axes, and their own example FROM MEMORY
  before revealing the card. It grades recall, then reschedules each card with expanding intervals
  (spacing effect) — good recall pushes the next review further out, shaky recall resets it short.
  Deliberately short: a handful of due cards per sitting. Invoke with /review-learnings, or when the
  user says "review my learnings", "quiz me on old concepts", "spaced review", "what's due to review",
  or "let's revise". This skill only REVIEWS; new concepts are created by teachable-moment.
---

# review-learnings

Turn the pile of concept cards in `/Users/adharshdhandapani/git/learning-from-experience/` into a spaced, interleaved retrieval workout.
Durable expertise comes from recalling a concept *cold* days/weeks later and discriminating it from
similar ones — not from rereading. This skill enforces exactly that.

**Keep it short:** a handful of due cards per sitting (default cap 5). Better to finish 4 cards well
than to start 15 and bail.

## Workflow

### Step 1 — Find what's due

- Read `/Users/adharshdhandapani/git/learning-from-experience/README.md` (the learnings index/log). If it's missing or empty, tell the
  user there's nothing to review yet and to build cards with `/teachable-moment` first. Stop.
- Get today's date (`date +%F`). Select cards whose **Next review** date is today or earlier (due /
  overdue). Order most-overdue first.
- **Interleave:** to the due set, add 1-2 cards from *different* topics/domains even if not yet due —
  mixing is what trains discrimination. (If the arg is `all`, include everything; if the arg names a
  concept, review just that one.)
- Cap the session at 5 cards. Tell the user how many are due and which you'll cover this sitting.

### Step 2 — Cold retrieval, one card at a time

For each selected card, do NOT show the card first. Retrieval before reveal.

1. Show **only the concept name** and its one-line "where I met this" hook. Ask the user, via
   `AskUserQuestion` or open prompt, to reconstruct FROM MEMORY: (a) the option space + the 1-2
   confusable distractors, (b) the decision axes/rule, (c) a fresh example where it'd apply. Tell them
   to try even if fuzzy — effortful failure is productive.
2. **Then** reveal the card (Read the HTML, summarize its option table + rule). Have the user
   self-grade recall: Solid / Partial / Blank.
3. **One interleaved discrimination question:** pose a scenario that sits between THIS concept and a
   *confusable* one from another card, and ask which applies and why. This is the far-transfer check.
4. Grade in one line; correct gaps in 2-4 lines; teach on misses.

### Step 3 — Reschedule (the spacing engine)

For each reviewed card, set its new **Next review** date by expanding or resetting the interval
(a simple Leitner/SRS ladder). Compute dates with macOS `date -v+Nd +%F`.

| Recall this session | New interval from today |
|---|---|
| Solid (nailed cold recall + discrimination) | step UP the ladder: 1d → 3d → 1w → 3w → 2mo → 4mo |
| Partial | keep roughly the same interval (repeat the current rung) |
| Blank / wrong | reset to short: **+1 day** |

- Update the card's `data-due` attribute and visible "Next review" line (Edit the HTML).
- Update that card's row in `README.md`: new **Next review** date, and refresh the **Shaky** column
  with anything that came up this session.
- Keep a running note of which rung each card is on (store it in the README row, e.g. `rung:3`), so
  the ladder is stateful across sittings.

### Step 4 — Close out

Short chat summary: cards reviewed, how many solid vs shaky, and the next date something comes due.
Under 6 lines. Offer to keep going if more are due, or to hand a shaky concept to `/teachable-moment`
for a fresh deep session.

## Hard rules

- **Retrieval before reveal, always.** Never show the card content before the user has tried to
  reconstruct it from memory. Rereading first defeats the entire purpose.
- **Interleave.** Always mix at least one card/question from a different topic; always include one
  discrimination question against a confusable concept.
- **One card / one question at a time**, via `AskUserQuestion`. Never batch.
- **Cap the session** (default 5 cards). Short and finished beats long and abandoned.
- **Always reschedule** every reviewed card and persist the new due-date + rung to the card and the
  README. The spacing is worthless if it isn't written back.
- **This skill never creates new concepts** — if a card is badly shaky, hand it to `/teachable-moment`.
