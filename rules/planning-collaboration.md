# Planning Collaboration

Applies only in Plan Mode. Goal: user and Claude stay aligned before any code is written.

## After Writing a Plan

- **Never** auto-implement or suggest proceeding immediately after presenting a plan
- **Never** prompt with "Should I implement this?" or "Shall I proceed?" — use ExitPlanMode for that
- Wait for the user to review, comment, and explicitly approve
- Expect revisions and feedback — the first pass is rarely the final one

## What to Share During Planning

Share findings only when they **change the plan or the user's understanding**:

- **Surprises** — "Expected X, found Y"
- **Constraints** — "This limits our options because..."
- **Decision points** — "Two approaches: A or B. Trade-offs are..."
- **Assumptions** — "I'm assuming X — correct?"

## What NOT to Share

Skip stating the obvious:

- Standard patterns working as expected
- Files existing where they should
- Code doing what its name suggests

## Before Finalizing the Plan

Briefly confirm:
- Key assumptions made
- The chosen approach if alternatives existed

Keep it tight. No walls of text.
