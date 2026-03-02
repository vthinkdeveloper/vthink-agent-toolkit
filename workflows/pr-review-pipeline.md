---
name: pr-review-pipeline
description: >
  End-to-end PR review pipeline. Runs conventions check, test suite, and
  generates a QA guide in sequence for a given PR number. Invoke with
  /pr-review-pipeline <PR-number>.
version: 1.0.0
author: adharsh2208vthink
tags: [pr, review, qa, testing, conventions, pipeline]
argument-hint: "<PR-number>"
---

# PR Review Pipeline

A three-stage pipeline that runs a full quality review on a pull request:

1. **Conventions check** — validates code style and patterns
2. **Test runner** — runs the test suite and fixes failures
3. **QA guide** — generates a human-readable testing guide for QA

## Usage

```
/pr-review-pipeline 123
```

## Workflow

### Stage 1: Conventions Check

Use the `conventions-check` skill on the PR:

```
Run the conventions-check skill for PR #$ARGUMENTS
```

- Report all errors, warnings, and info findings
- If errors are found, flag them clearly — the PR should not merge with convention errors
- Continue to Stage 2 regardless (report all findings together at the end)

### Stage 2: Test Runner

Delegate to the `test-runner` agent:

```
Use the test-runner agent to run the test suite and report results
```

- Report pass/fail counts
- If tests fail, attempt fixes and re-run
- Note any tests that couldn't be fixed and why

### Stage 3: QA Guide

Use the `qa-guide` skill for the PR:

```
Run the qa-guide skill for PR #$ARGUMENTS
```

- Generate and save the QA guide to `docs/qa-guide-pr-$ARGUMENTS.md`

### Final Summary

After all three stages, present a consolidated report:

```
## PR #<number> Review Summary

### Conventions Check
- Result: PASS / FAIL (<N> errors, <N> warnings)
- [List errors if any]

### Tests
- Result: PASS / FAIL (<N> passed, <N> failed)
- [List failures if any]

### QA Guide
- Saved to: docs/qa-guide-pr-<number>.md

### Recommendation
READY TO MERGE / NEEDS FIXES
[1-2 sentences explaining the recommendation]
```
