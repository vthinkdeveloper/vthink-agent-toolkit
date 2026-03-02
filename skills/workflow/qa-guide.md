---
name: qa-guide
description: Generate a comprehensive QA testing guide for a GitHub Pull Request. Analyzes the PR diff, researches the codebase for impact, and produces a structured test plan written for QA testers.
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [qa, testing, pull-request, test-plan]
argument-hint: <PR-number>
allowed-tools: Bash(gh *), Read, Grep, Glob, Write
---

# QA Testing Guide Generator

You are generating a QA testing guide for PR #$ARGUMENTS.

## PR Data (pre-fetched)

### PR Metadata
!`gh pr view $ARGUMENTS --json title,body,baseRefName,headRefName,additions,deletions,changedFiles,labels,files`

### Changed Files
!`gh pr diff $ARGUMENTS --name-only`

### Full Diff
!`gh pr diff $ARGUMENTS`

## Your Task

Analyze the PR data above, then research the codebase to understand the full context and impact of the changes. Produce a QA testing guide saved to `docs/qa-guide-pr-$ARGUMENTS.md`.

## Step 1: Understand the Changes

Read through the diff and PR description to understand:
- What feature was added or what bug was fixed
- Which areas of the application are touched
- What the user-visible behavior change is

## Step 2: Research the Codebase

For each changed file, research its context:
1. **Read the full current file** to understand the complete component, not just the diff
2. **Find callers/consumers** using Grep to search for class names, method names, component names, and import references — this reveals what other parts of the app depend on the changed code
3. **Find related test files** to understand existing test coverage
4. **Check configuration files** if the change introduces or uses new properties or settings
5. **For frontend changes**, trace which pages/views use the changed components and how user interactions flow through them

## Step 3: Generate the QA Guide

Write the guide to `docs/qa-guide-pr-$ARGUMENTS.md` using the template below.

**Critical rules for the guide:**
- The audience is a QA tester who knows the product broadly but is NOT familiar with this specific feature or fix
- Write ZERO code, file paths, class names, or technical implementation details
- Describe everything in terms of what the user sees and does in the application
- Test steps should be exact: "Click the X button in the top-right corner of the dashboard", not "Test the feature"
- Explain the feature/fix context so the tester understands WHY they are testing what they are testing

## Output Template

```markdown
# QA Testing Guide - PR #<number>: <title>

**Date:** <today's date>
**Branch:** <head> -> <base>
**Scope:** <number of files changed> files (+<additions> / -<deletions>)

---

## 1. What This PR Does

<Explain the feature or fix in 2-3 paragraphs using plain, non-technical language. Assume the reader is new to this part of the application. Cover:
- What problem existed or what capability was missing
- What this PR changes from the user's perspective
- Why it matters>

## 2. Areas of the Application Affected

<List the parts of the app that are affected, described in user-facing terms. For example: "Dashboard editor", "Report export", "Login flow", "Chart display settings". Group them as:>

### Directly Changed
- <area> — <what changed here>

### Could Be Indirectly Affected
- <area> — <why it might be affected>

### Risk Assessment
| Area | Risk | Why |
|------|------|-----|
| <area> | High / Medium / Low | <plain-language reason> |

## 3. Test Scenarios

### 3.1 Core Functionality (Happy Path)
| # | Scenario | Steps | Expected Result |
|---|----------|-------|-----------------|
| 1 | <what you're testing> | 1. <exact UI action><br>2. <exact UI action><br>3. <exact UI action> | <what you should see> |

### 3.2 Edge Cases
| # | Scenario | Steps | Expected Result |
|---|----------|-------|-----------------|
| 1 | <boundary or unusual condition> | 1. <step><br>2. <step> | <expected behavior> |

### 3.3 Error Handling
| # | Scenario | Steps | Expected Result |
|---|----------|-------|-----------------|
| 1 | <what goes wrong> | 1. <step><br>2. <step> | <how the app should respond> |

### 3.4 Regression Checks
<Things that worked before and should still work after this change.>
| # | Area | What to Verify |
|---|------|---------------|
| 1 | <feature> | <what should still work normally> |

## 4. Setup Before Testing

### Environment
- <any environment or server requirements>

### Test Data Needed
- <describe what data/content the tester needs to have set up>

### Configuration
- <any settings or toggles that need to be in a specific state>

## 5. Browser / Device Testing
<ONLY include this section if the PR has frontend/UI changes. Otherwise omit entirely.>

### Browsers to Test
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

### Responsive Testing
- <specific screen sizes or breakpoints to verify, if relevant>

### Accessibility
- <keyboard navigation, screen reader, or contrast checks if relevant>
```
