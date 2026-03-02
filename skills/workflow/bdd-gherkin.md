---
name: bdd-gherkin
description: >
  Generate BDD Gherkin feature files from requirements — even vague ones. This skill collaborates
  with the user by asking targeted clarifying questions to uncover hidden assumptions, edge cases,
  and acceptance criteria, then produces well-structured Given/When/Then scenarios. No source code
  needed. Use this skill whenever the user asks to write BDD requirements, Gherkin scenarios,
  .feature files, acceptance criteria in Given/When/Then format, or behavior-driven test
  specifications. Also trigger when the user mentions "BDD", "Gherkin", "Cucumber", "feature file",
  "acceptance tests", or "Given/When/Then" in the context of writing requirements or test scenarios.
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [bdd, gherkin, cucumber, testing, requirements, acceptance-criteria]
---

# BDD Gherkin Scenario Generator

## Overview

This skill turns requirements — even rough, vague, or incomplete ones — into comprehensive BDD Gherkin scenarios. Instead of analyzing code, it **collaborates with the user** through focused questions to surface the full picture before writing scenarios.

The key insight: most requirements start vague. "Users should be able to reset their password" sounds simple until you ask about email delivery failures, expired tokens, and locked accounts. This skill's job is to ask those questions early, then write scenarios that capture the answers.

## Workflow

### Step 1: Receive the Requirement

The user provides a requirement. It could be anything from a one-liner to a detailed spec. Accept whatever they give without complaint — your job is to work with it.

**Examples of inputs you should handle well:**
- "Users should be able to export reports"
- "We need an admin page to manage user roles"
- "Add filtering to the dashboard"
- A Jira ticket description pasted in
- A screenshot of a mockup or wireframe
- A bullet-point list of desired behaviors

### Step 2: Understand and Clarify (The Collaborative Part)

This is the most important step. Before writing any Gherkin, have a short conversation to fill in the gaps. Your goal is to ask **just enough** questions to write meaningful scenarios — not to interrogate the user into exhaustion.

**How to ask questions:**

Use the AskUserQuestion tool to present focused, structured questions. Group related questions together. Offer concrete options where possible so the user can pick rather than think from scratch.

**What to probe for:**

| Gap to fill | Example questions |
|---|---|
| **Who** — the actor(s) | "Who performs this action? Admin only, any logged-in user, or unauthenticated users too?" |
| **What** — the core action | "When you say 'export', what formats? PDF, Excel, CSV, all of them?" |
| **When** — triggers and preconditions | "Can they do this anytime, or only when certain conditions are met?" |
| **Where** — the UI context | "Is this on a dedicated page, a modal, or part of an existing screen?" |
| **What if** — failure and edge cases | "What should happen if the export fails? Retry? Error message? Silent failure?" |
| **Who else** — impact on others | "Should other users be able to see/access the exported file?" |
| **Boundaries** — limits and constraints | "Is there a max number of rows? A timeout? Size limit?" |

**Rules for questioning:**

1. **Ask 3-5 questions max per round.** Don't overwhelm. You can always ask follow-ups.
2. **Provide sensible defaults.** "I'll assume any logged-in user can do this unless you say otherwise."
3. **State your assumptions explicitly.** Let the user correct you rather than making them think of everything.
4. **Skip obvious questions.** If the requirement says "admin page", don't ask "who is the actor?"
5. **Offer options, not open blanks.** "Should the error be (a) inline message, (b) toast notification, or (c) modal?" is better than "how should errors be displayed?"
6. **One round is often enough.** If the requirement is reasonably clear, state your assumptions and go straight to writing. Don't force conversation for its own sake.

**When to skip questions entirely:**

If the requirement is detailed enough (e.g., a well-written user story with acceptance criteria), state your interpretation briefly and go straight to scenarios. You can always refine after the user reviews.

### Step 3: State Your Assumptions

Before writing scenarios, briefly list the assumptions you're working with. This gives the user a chance to correct course before you invest in writing.

Format:
```
Based on our discussion, here's what I'm working with:
- Actor: Admin users only
- The export runs in the background (not blocking)
- Supported formats: PDF and Excel
- Error handling: toast notification with retry option
- No file size limit for now

I'll write scenarios covering: happy path, format selection, error handling, and permissions. Let me know if I'm missing anything, otherwise I'll proceed.
```

Keep it short. This is a checkpoint, not a document.

### Step 4: Write the Gherkin

**Feature organization — break into separate Features when:**
- Different user roles are involved (admin config vs. end-user viewing)
- Different screens or pages in the application
- Configuration vs. consumption of that configuration
- The requirement naturally splits into independent capabilities

**Scenario coverage checklist:**
For each feature, consider these categories (not all will apply):

1. **Happy paths** — The main success scenarios
2. **Authorization & access** — Who can and can't do this?
3. **User interactions** — Every button, selection, form field
4. **Validation** — What inputs are rejected? What messages appear?
5. **Save/submit** — Success confirmation, what changes?
6. **Cancel/back out** — Can the user abandon without side effects?
7. **Error handling** — Failures, timeouts, network issues
8. **Edge cases** — Empty states, boundary values, concurrent users
9. **Persistence** — Does the change survive logout/login?
10. **Downstream effects** — How does this affect other parts of the system?

**Don't force coverage.** Only write scenarios for categories that are relevant. A simple toggle setting doesn't need 10 categories of scenarios.

### Step 5: Review and Iterate

After presenting the scenarios, explicitly invite feedback:
- "Are there scenarios missing that you expected to see?"
- "Should any of these be split, merged, or removed?"
- "Do the scenario names make sense to your team?"

Be ready to add, remove, or rewrite scenarios based on feedback. This is collaborative — the first pass is a draft, not a final product.

### Step 6: Output Format

**Default:** Show scenarios directly in the conversation, organized by Feature.

**If the user asks for files:** Create `.feature` files and save them to the project's docs or test directory.

**Always include** a brief coverage summary at the end showing what categories of behavior are covered.

## Writing Principles

**Write for the user, not the developer.** Say "I click the Save button" not "I send a PUT request to /api/v1/settings". Say "I should see an error message" not "the response status should be 500".

**Be specific about outcomes.** Don't say "an error is displayed" — say "I should see the message 'Export failed. Please try again.'" If you don't know the exact message, use a realistic placeholder and mark it with a comment.

**Use Background for shared setup.** If every scenario starts with "Given I am logged in as an admin", put it in Background. But don't overload it.

**Scenario Outlines for data-driven variations.** When the same flow works with different inputs, use Scenario Outline with Examples tables rather than duplicating scenarios.

**One behavior per scenario.** Each scenario tests exactly one thing. If you're writing "And then also..." you probably need two scenarios.

**Name scenarios descriptively.** The name should tell you what's being tested without reading the steps. "Admin exports report as PDF" beats "Test export".

**Use realistic data.** Don't use "test123" or "foo" — use "Q4 Sales Report" and "jane.smith@company.com". Realistic data makes scenarios readable and catches assumptions.

**Tag strategically.** Use tags like `@smoke`, `@admin`, `@regression`, `@wip` to help organize and filter scenarios.
