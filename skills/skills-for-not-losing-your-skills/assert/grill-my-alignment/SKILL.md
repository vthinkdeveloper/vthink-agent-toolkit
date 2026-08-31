---
name: grill-my-alignment
description: Relentlessly quiz the user on the concepts an alignment session already taught, to verify the understanding actually stuck. Reads a docs/<topic>-alignment.html doc ONLY to learn which concepts are in scope (the taught prerequisites, claims, and decisions), then authors its OWN comprehensive, relentless grilling plan for each concept from first principles — it does NOT turn the doc's Q&A log into the questions; it consults the Q&A log and decisions only as reference for what was covered and why, and probes deeper/broader than the doc does. Grills ONE question at a time — open-ended "explain / why / what-breaks-if / spot-the-flaw" questions preferred, MCQs as a change of pace. Grades each answer, corrects gaps on the spot, and ends with a scorecard of solid vs shaky concepts. Use when the user says "grill my alignment", "grill me on what I learned", "quiz me on the alignment", "test my understanding", or wants to prove a topic stuck before moving on. This is the verify counterpart to work-towards-alignment (which teaches); it never teaches new material as its main job, it tests.
---

# grill-my-alignment

Verify, don't teach. `work-towards-alignment` builds understanding and marks concepts `taught`; this skill **checks whether that understanding is real** by grilling the user on it, one question at a time, until every taught concept has been probed and the user is either solid or has a named gap.

The stance is a supportive oral exam (a *viva*), not a gotcha. The goal is mastery: surface what's shaky so it can be re-learned, and give the user honest confidence in what's solid.

## Inputs

- **Argument (optional):** a path to an alignment doc (`docs/<topic>-alignment.html`), a topic name, or a scope like "Point 4" / "Mann-Kendall". If omitted, auto-select the **most recently modified** `docs/*-alignment.html` and confirm it with the user in one line before starting.
- The alignment doc is the source of truth for **what to quiz**: only grill concepts marked `taught` or `known` (and the accepted claims / decisions). Do **not** quiz `pending`/`skipped` prerequisites — they were never taught, so testing them is unfair.

## Workflow

### Step 1 — Derive the SCOPE from the doc, then author your OWN grilling plan (silently)

The alignment doc tells you **what to grill**, not **how**. Do NOT convert the Q&A log into the questions — that would test whether the user re-read the doc, not whether they understand the concept.

**1a. Scope (from the doc):** list every concept that is fair game:
- Each **`taught`/`known` prerequisite** badge (e.g. "4.7b The S score", "5.1 Median vs mean").
- Each **accepted claim / Point** and each **decision** (what was chosen/rejected and why).
- Skip `pending`/`skipped` — never taught, never quizzed.

**1b. Your own plan (from first principles):** for each in-scope concept, design your *own* comprehensive set of probes using your knowledge of the domain — aim to test genuine understanding from angles the doc may not have covered:
- the core mechanic ("explain how X works"),
- the *why* ("why X over the alternative"),
- the failure mode ("what breaks without X"),
- transfer ("apply X to this new example I invent on the spot"),
- and misconception traps ("here's a plausible-but-wrong statement about X — is it right?").

Invent fresh examples and numbers rather than reusing the doc's. Probe **deeper and broader** than the doc — the doc is the floor of coverage, not the ceiling.

**1c. Reference only when needed:** consult the Q&A log / decisions to confirm *what was actually taught and decided* (so you don't grill a nuance that was explicitly out of scope, or contradict a settled decision). Reference, not script.

Group by item (Point 1, Point 2, …) so you can cover breadth first, then depth. Tell the user in one line: how many concepts are in scope and that you'll go one question at a time until each is checked.

### Step 2 — For each question: author it well, hide the rubric

Before showing a question, do this privately (never reveal any of it):

- Write the **target concept**, a **gold-standard reference answer** in your own words, the **required idea-units** (the specific points a correct answer must contain), and the **common misconceptions / disqualifying errors**. This is the rubric you will grade against — not a vibe.
- Author the **question text separately** from that rubric, with guardrails on the stem:
  - It must NOT contain the words from the concept's own definition (no answer leakage in the premise).
  - No undefined pronouns or vague referents — a second expert should read it identically. Ambiguity check: *"could two experts reasonably read this differently?"* If yes, rewrite (a failed answer must reflect a knowledge gap, not a confusing question).
  - Generate ~3 candidate stems internally; keep the **least leading and most discriminative** one.
  - Tag its cognitive level: recall / explain / compare / apply-transfer / diagnose.
- A genuine **transfer** question uses a **new example with new numbers**, not a paraphrase of the taught one (avoid the surface-variant illusion — a reworded question that tests the same rote recall isn't transfer).

Then ask — ONE question, wait. Open-ended preferred:
- *"Explain X in your own words."* · *"Why X over Y?"* · *"What breaks if we didn't have X?"* · *"Apply X to this: <fresh example>."* · *"Here's a claim: '…' — right? Fix it."* (spot-the-flaw)
- MCQs (via `AskUserQuestion`) only as an occasional change of pace; open-ended reveals more.

### Step 3 — Confidence first, then grade against the rubric

1. After the answer, and **before revealing any verdict**, ask **confidence** ("how sure are you this is right, 1-5?"). Record it. **Confident-and-wrong = a deeply held misconception** (🔴-critical, needs real re-teaching, not a nudge); uncertain-and-wrong = a plain gap.
2. **Grade against the pre-authored rubric, not holistically.** Check the idea-units explicitly:
   - A long, fluent, jargon-rich answer that misses the causal mechanism is a **gap, not solid** — this is the #1 failure mode (verbosity / fluency false-positive); guard it hard.
   - A concise answer worded differently, or a valid *alternative* mental model that still hits the idea-units, is **solid** — don't false-negative unconventional-but-correct answers.
3. Grade as a **distinct step from authoring**, so you don't reward your own phrasing (circularity). For a high-stakes concept, re-judge the transcript once more against the rubric.

Verdict: ✅ solid / 🟡 partial / 🔴 gap — always name the specific missing idea-unit, plus the confidence-vs-correctness note.

### Step 4 — Passes: diagnose clean, then teach-and-reconfirm (automatically)

- **Pass 1 — pure diagnostic breadth. NO correcting or teaching.** One question per concept, concepts **interleaved (shuffled), not walked in list order** (linear order leaks context cues that inflate answers). Record verdict + confidence only. Do not reveal answers or coach — here you measure what the *teaching* left behind, not what your own hint just planted; correcting mid-diagnosis contaminates the later re-test.
- **Pass 2 — the teach-then-reconfirm LOOP, run automatically.** For each shaky/wrong concept: **teach the specific gap** (briefly, on the spot), **then immediately re-grill it with a freshly-worded question** to confirm it stuck. Still wrong? Teach again from a different angle and re-grill again — loop until solid or the user is clearly stuck (then name it and move on). **This whole loop is Claude's job — run it without asking permission.** The user answers questions; you decide when to teach, what to teach, and when to re-test. Never gate a step on "want me to teach this?" / "shall I re-grill?" / "continue?" — just do it. The core cycle the user expects: *grill → (on a miss) teach → grill again to be sure.*
- **Two-tier clear:** a concept is not ✅ on an explanation alone — it needs BOTH a Tier-1 (explain in own words) AND a Tier-2 (apply to a novel scenario) answered correctly, on *fresh* questions.
- **"Sure" is earned in-session, NOT by waiting.** A concept is confirmed by a fresh same-session re-grill (explain + transfer), full stop. **Do NOT schedule or recommend a "come back in a day / a few days" spaced re-check.** Two reasons: the user often has no time luxury for it, and Claude has **no reliable sense of elapsed wall-clock time** within a conversation, so "N days later" claims are meaningless. Confirm now, with fresh questions; don't promise a future re-test.

### Step 5 — Scorecard

Compact scorecard, each label backed by **evidence** (which prompts, which missed idea-units, the confidence calibration):

- ✅ **Solid** — cleared the two-tier bar this session (explain + transfer, fresh questions).
- 🟡 **Shaky:** re-grilled after teaching, now ok / still soft.
- 🔴 **Gaps / critical misconceptions** — flag *confident-but-wrong* separately; these need real re-teaching.
- **Headline** + the **verified bar**: do NOT call a concept *verified* unless it cleared **≥2 distinct prompts (at least one transfer), with acceptable confidence calibration**. (No "durable/delayed" tier — verification is same-session only; don't imply a future re-check is owed.)

Offer to save the scorecard (append a `grill` entry to the alignment doc, or a short `docs/<topic>-grill-YYYY-MM-DD.md`) if the user wants a record.

## Interaction with the alignment doc (important)

- **This skill does not teach as its purpose and does not silently change the alignment doc.**
- If grilling reveals a concept marked `taught` is actually a 🔴 gap, **surface it and offer to demote the badge back to `pending`** for re-teaching in a `work-towards-alignment` session — **only with the user's explicit approval.** Never flip a badge (either direction) on your own judgment; the user owns the "I understand" signal. (Same rule the alignment skill follows.)
- If the user wants to *learn* a gap right now rather than just note it, hand back to teaching mode explicitly ("want to switch to CWA on this one?") rather than turning the grill into a lecture.

## Hard rules

- **One question at a time.** Wait for the answer. No batching.
- **Never quiz un-taught (`pending`/`skipped`) concepts.**
- **Don't give the answer away in the question.** Stem must not contain the concept's definition words, and must pass the ambiguity check.
- **Always grade against a pre-authored rubric + reference answer + misconception list** — never a holistic "felt right" verdict. The verbosity/fluency false-positive is the primary failure mode.
- **Ask confidence before revealing the verdict.** Confident-and-wrong is a critical misconception, not a normal gap.
- **Pass 1 is pure diagnostic — no correcting or teaching there.** Remediation happens in Pass 2 only, so the diagnosis isn't contaminated by your own hints.
- **Interleave concepts** (shuffle order); **two-tier clear** (explain + transfer); honor the **verified bar** (≥2 distinct prompts incl. one transfer + calibration). Verification is **same-session only** — never schedule or promise a "days later" spaced re-check (no time luxury; Claude has no reliable sense of elapsed time).
- **The teach-then-reconfirm loop is automatic.** On a wrong/shaky answer, teach the gap and then re-grill it on a fresh question yourself — do NOT ask "want me to teach this?" or "shall I re-grill?". Grill → (miss) → teach → grill again to be sure, driven by you.
- **Grade honestly** — false "correct!" praise defeats the point; name the missing idea-unit.
- **Relentless, not infinite:** cover the whole map (breadth then depth), but stop the moment the user says stop, and always end with the scorecard.
- **Drive the session — do NOT nag with menus.** The user started the grill to master the material; *you* run it. Ask the grill/teaching QUESTION, grade the answer, then move straight to the next concept — do **not** ask "want me to X or Y next?", "flip it and move on?", "shall I continue?" between concepts. No choose-your-own-adventure prompting; it breaks flow and reads as nagging. Only pause for a genuine fork the user alone owns (real fatigue → "stop here?"; or an answer that forces a branch). Bookkeeping the user already implied wanting (updating the scorecard/doc, saving the entry) — **just do it, don't ask permission.** The only thing you should routinely put to the user is the next *question* and the *confidence* prompt — never a process menu.
- **Never edit the alignment doc's badges without explicit user approval** (demotion of a failed concept included).
- **Timeouts never advance the session** — hold the question, wait for a real reply.
- **Supportive tone.** It's a viva to build genuine confidence, not a trap.
