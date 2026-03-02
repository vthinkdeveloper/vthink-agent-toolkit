---
name: feature-development
description: >
  End-to-end feature development workflow. Takes a feature description,
  generates BDD scenarios for sign-off, implements the feature, runs
  tests, and ships. Invoke with /feature-development "<feature description>".
version: 1.0.0
author: adharsh2208vthink
tags: [feature, bdd, implementation, testing, ship, workflow]
argument-hint: '"<feature description>"'
---

# Feature Development Workflow

A full-cycle workflow from feature description to shipped code:

1. **BDD scenarios** — clarify requirements and get sign-off before coding
2. **Implementation** — build the feature following project conventions
3. **Test runner** — verify everything passes
4. **Ship** — commit and push

## Usage

```
/feature-development "add export to CSV on the reports page"
```

## Workflow

### Stage 1: BDD Scenarios (Requirements Sign-off)

Use the `bdd-gherkin` skill with the feature description:

```
Run the bdd-gherkin skill for: $ARGUMENTS
```

- Collaborate with the user to clarify requirements
- Produce Gherkin scenarios covering happy path, edge cases, and error handling
- **Stop here and wait for explicit user approval of the scenarios before proceeding**
- Do not start implementation until the user confirms the scenarios are correct

### Stage 2: Implementation

Once scenarios are approved:

1. Read the relevant parts of the codebase to understand the existing structure
2. Implement the feature following the approved scenarios as acceptance criteria
3. Use the `conventions-check` skill to validate your changes before finalising:
   ```
   Run conventions-check on the changed files
   ```
4. Fix any convention errors before moving to Stage 3

### Stage 3: Tests

Delegate to the `test-runner` agent:

```
Use the test-runner agent to run the full test suite
```

- All existing tests must still pass
- If the project uses BDD/integration tests, verify the new scenarios pass too
- Fix any regressions before proceeding

### Stage 4: Ship

Use the `ship` skill:

```
Run the ship skill
```

- Runs a final conventions check on staged files
- Generates a commit message with ticket ID from branch name
- Commits and pushes

### Final Summary

```
## Feature Development Complete

### Feature
<Feature description>

### Scenarios Implemented
<Count> BDD scenarios — [link to .feature file if created]

### Tests
All <N> tests passing

### Shipped
Branch: <branch>
Commit: <hash> <message>
```
