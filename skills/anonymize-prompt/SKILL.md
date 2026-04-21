---
name: anonymize-prompt
description: Generate a privacy-safe version of the current technical problem, safe to paste into external tools. Strips company names, project names, class names, URLs, and internal terminology while preserving the technical substance. Use when you need to search externally without leaking proprietary details.
---

# Anonymize Prompt

Generate a privacy-safe, anonymized prompt that the user can paste into external search engines and AI chatbots to get help — without exposing ANY proprietary details.

## Inputs

1. **Conversation context** — the current conversation where the problem is being discussed
2. **User's argument** (optional) — a plain-text description of the problem passed as the skill argument

## Workflow

### Step 1: Understand the Problem

From the conversation context and user's argument, identify:
- What is the core technical problem?
- What technologies/frameworks are involved? (these are public knowledge — keep them)
- What error messages or symptoms are observed?
- What has been tried so far?

### Step 2: Anonymize Everything Proprietary

Apply ALL of the following replacements systematically:

| Category | Example Before | Example After |
|----------|---------------|---------------|
| Company/product names | AcmeCorp, my-service | "our application", "the project" |
| Class names | `OrderManager`, `PaymentTracker` | `DataManager`, `ProcessTracker` |
| Variable/method names | `buildOrderInstance()` | `buildDataStructure()` |
| Package paths | `com.acme.app.apiImpl` | `com.example.app.impl` |
| Internal URLs | `localhost:8080/internal/api/v0` | `localhost:8080/app/api/v1` |
| Database/table names | `acme_metadata`, `order_definitions` | `app_metadata`, `entity_definitions` |
| Internal jargon | proprietary domain terms | describe functionally in plain language |
| File paths | `/src/main/java/com/acme/...` | `/src/main/java/com/example/...` |
| Config keys | `acme.security.*` | `app.security.*` |
| Ticket IDs | PROJ-1931 | remove entirely |
| Branch names | PROJ-1931-add-offline-access | remove entirely |
| Colleague names | any person names | remove entirely |
| Docker/service names | my-api, acme-web | "the api service", "the web service" |

### Step 3: Preserve Technical Accuracy

Keep ALL of the following (they are public knowledge):
- Framework names: Spring, Spring Security, Hibernate, React, Redux, Webpack, Maven, etc.
- Library versions: Spring 5.x, Java 14, PostgreSQL 12, etc.
- Standard patterns: OAuth2/OIDC, REST, JDBC, ACL, etc.
- Error messages (but scrub any proprietary class/package names within them)
- Stack trace structure (but anonymize class names)
- Configuration property formats (but anonymize the property names)

### Step 4: Problem-Only Output

**IMPORTANT:** Only describe the **problem** — never include solutions, fixes, or workarounds. The goal is to get unbiased answers from external engines. Including a fix will bias the response toward confirming that fix rather than exploring all options.

- Describe the symptoms and constraints clearly
- End with an open-ended question like "What are the best ways to solve this?"
- Do NOT suggest approaches, patterns, or specific technologies as answers

Produce the anonymized prompt in this format:

```
## Context
[1-2 sentences: what the app is, what tech stack, what area you're working in — all anonymized]

## Problem
[Clear description of the technical issue — specific enough to be searchable]

## What I've Tried
[List of approaches attempted, if any — anonymized]

## Error / Symptoms
[Any error messages, stack traces, or unexpected behavior — anonymized]

## Question
[Open-ended question asking for solutions — do NOT suggest any answers]
```

### Step 5: Self-Review Checklist

Before outputting, verify:
- [ ] No company or product names remain
- [ ] No internal class/method/variable names remain
- [ ] No internal file paths remain
- [ ] No proprietary package names remain
- [ ] No ticket IDs or branch names remain
- [ ] No person names remain
- [ ] No internal URLs remain
- [ ] The problem is still technically accurate and specific
- [ ] Someone reading this would have NO idea which company or project this is from

## Output

Present the anonymized prompt inside a fenced code block so the user can easily copy-paste it.

Add a brief note above the code block: "Here's your anonymized prompt — safe to paste into external search engines and AI chatbots:"

If anything couldn't be fully anonymized (e.g., a very unique architectural pattern), flag it with a warning so the user can review before pasting.
