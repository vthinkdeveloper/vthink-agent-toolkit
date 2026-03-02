---
name: conventions-check
description: >
  Check code changes against project conventions. Supports two modes:
  a PR number (e.g., `/conventions-check 863`) to analyze a PR diff, or
  file paths/globs (e.g., `/conventions-check src/**/*.java`) to check
  specific files. Discovers conventions from the project's own codebase
  (CLAUDE.md, linter configs, existing patterns) and reports violations in
  naming, patterns, architecture, and file organization. Use this skill
  whenever someone asks to "check conventions", "review code style",
  "audit patterns", or "validate naming".
version: 1.0.0
author: adharsh2208vthink
category: workflow
tags: [code-quality, conventions, linting, review]
argument-hint: <PR-number or file-path>
allowed-tools: Bash(gh *), Read, Grep, Glob
---

# Code Conventions Checker

## Overview

This skill checks code changes against the conventions established in the project's own codebase. Rather than enforcing a fixed ruleset, it **discovers** conventions by examining the project's configuration files, documentation, and existing code patterns — then validates changes against those conventions.

It works in two modes:
- **PR mode**: Pass a PR number to analyze all changed files in a pull request
- **File mode**: Pass file paths or glob patterns to check specific files

## Workflow

### Step 1: Detect Input Mode and Gather Files

Determine if `$ARGUMENTS` is a PR number (digits only) or file path(s).

**If PR number (digits only):**
1. Use Bash to run: `gh pr diff <number> --name-only` to get the list of changed files
2. Use Bash to run: `gh pr diff <number>` to get the full diff for context
3. Read each changed file in full using the Read tool

**If file path(s) or glob pattern(s):**
1. Use Glob to expand any patterns and collect the list of files to check
2. Read each file's contents using the Read tool

### Step 2: Discover Project Conventions

Before checking anything, learn what conventions this specific project follows. Read these sources **in order of priority** (skip any that don't exist):

1. **`CLAUDE.md`** (project root) — Often contains explicit architecture, patterns, and coding conventions
2. **Linter/formatter configs** — Search for and read:
   - `.eslintrc`, `.eslintrc.js`, `.eslintrc.json`, `.eslintrc.yml`
   - `.prettierrc`, `prettier.config.js`
   - `checkstyle.xml`, `.editorconfig`
   - `tslint.json`, `biome.json`
   - `pom.xml` (for Java plugin configs like compiler version, encoding)
   - `package.json` (for `eslintConfig`, `prettier` fields, and scripts like `lint`)
3. **Existing code patterns** — For each file type being checked, read 2-3 existing files of the same type in the same directory or nearby directories to identify:
   - Naming conventions (classes, methods, files, variables)
   - Import ordering and style
   - Annotation/decorator usage patterns
   - Error handling patterns
   - Test structure and assertion style

### Step 3: Internal Consistency Analysis

Before checking against external rules, perform a **within-file consistency scan**. This catches deviations that no linter config would flag — patterns that are correct in isolation but inconsistent with the rest of the file:

1. **Collect all similar constructs** — group every instance of: error responses, status codes, variable naming style, string quote style, comment style, and return patterns
2. **Identify the dominant pattern** — for each group, determine what 80%+ of instances do (e.g., 4 out of 5 error responses use `{ error: '...' }`)
3. **Flag outliers** — any instance that deviates from the dominant pattern is a finding, even if the deviant form is valid on its own

This is critical because inconsistency within a single file is often more confusing to readers than a globally "wrong" but consistent style.

### Step 4: Analyze Changes Against Conventions

For each changed/target file, check against the applicable conventions based on file type. Apply discovered rules, filtered by what's actually relevant to this project.

**Severity levels:**
- **Error** — Clear violation of an explicit project rule (from CLAUDE.md, linter config, or universal convention)
- **Warning** — Deviation from the established pattern in surrounding code
- **Info** — Suggestion based on best practices that the project doesn't explicitly enforce but might benefit from

**For each finding, record:**
- File (user-friendly relative path)
- Line(s) affected
- Rule violated
- Severity (Error / Warning / Info)
- What was found vs. what was expected
- Suggested fix (one-liner)

### Step 5: Generate Report

Present findings in the conversation using this structure:

```
## Conventions Check Report

**Mode:** PR #<number> / Files: <list>
**Files checked:** <count>
**Findings:** <error-count> errors, <warning-count> warnings, <info-count> info

---

### Summary

| Severity | Count | Categories |
|----------|-------|------------|
| Error    | N     | <which rule categories> |
| Warning  | N     | <which rule categories> |
| Info     | N     | <which rule categories> |

### Findings by File

#### <relative/path/to/file.ext>

| # | Severity | Rule | Line(s) | Finding | Suggestion |
|---|----------|------|---------|---------|------------|
| 1 | Error    | <rule-id> | 42 | <what's wrong> | <how to fix> |
| 2 | Warning  | <rule-id> | 15-18 | <what's wrong> | <how to fix> |

### Conventions Discovered

<Brief list of conventions that were auto-discovered from this project's config and code patterns, so the user can verify the checker's understanding.>
```

**If no findings:** Report a clean bill of health with a summary of what was checked.

**Important rules for the report:**
- Always use relative file paths from the project root
- Include line numbers so developers can navigate directly
- Keep suggestions actionable and specific — "Rename to `FooService`" not "Follow naming conventions"
- Group findings by file, ordered by severity (errors first)
- Don't report on files that have zero findings (keep the report focused)
- If a convention conflict is found (e.g., CLAUDE.md says one thing but existing code does another), flag it as Info and note the discrepancy
