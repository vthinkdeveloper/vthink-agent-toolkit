---
name: generate-endpoint
description: >
  Generate a complete CRUD endpoint for a new resource. Auto-detects the
  project structure (routes file, db/models layer, test framework) and adapts
  generation accordingly. Works with Express, Fastify, Flask, and similar
  frameworks. Invoke with /generate-endpoint <resource-name>.
version: 1.0.0
author: adharsh2208vthink
category: backend
tags: [crud, api, rest, endpoint, code-generation]
argument-hint: "<resource-name>"
allowed-tools: Read, Grep, Glob, Write, Edit, AskUserQuestion
---

# Generate Endpoint

Generate a complete CRUD endpoint for a new resource, adapting to the project's existing structure and conventions.

## Step 1: Detect Project Structure

Before generating anything, explore the project to understand how it's organized:

### Find the routes/controller layer
Search for common patterns:
```
Glob: src/routes/*.js, app/routes/*.py, routes/*.js, controllers/*.js
Grep: "router.get\|app.get\|@app.route\|@router.get"
```

### Find the database/model layer
```
Glob: src/db.js, src/models/*.js, db/*.js, models/*.py, prisma/schema.prisma
Grep: "CREATE TABLE\|sequelize.define\|mongoose.model\|db.prepare"
```

### Find the test layer
```
Glob: tests/*.test.js, __tests__/*.js, test_*.py, spec/**/*.js
```

### Check package.json / requirements for framework clues
Read `package.json` or `requirements.txt` to identify the framework and test runner.

### If structure is ambiguous
Ask the user:
- "Where should I add the routes? (e.g., `src/app.js`, `src/routes/`)"
- "Where should I add the database queries? (e.g., `src/db.js`, `src/models/`)"
- "What test framework is this project using?"

## Step 2: Ask for Resource Details

Ask the user:
1. What is the resource name? (should be lowercase plural, e.g., `products`, `orders`)
2. What columns/fields does this resource need beyond `id` and `created_at`?

Example prompt:
> "I'll generate a CRUD endpoint for `products`. What fields does a product have? For example: `name (text)`, `price (decimal)`, `in_stock (boolean)`. I'll include `id` and `created_at` automatically."

## Step 3: Read Existing Patterns

Read 1-2 existing route handlers and db functions to understand the conventions:
- How are responses structured? `{ data: [...] }` or flat arrays?
- How are errors handled? Try/catch with status codes? Error middleware?
- What HTTP status codes are used for create (201 vs 200)?
- What is the naming style for functions? `getAllProducts` vs `fetchProducts` vs `list_products`?

Follow the patterns you find. Do not introduce new patterns.

## Step 4: Generate the Code

Generate the following, adapted to the detected framework and conventions:

### Database / Model Layer

Add CRUD functions for the new resource:
- `getAll<Resource>()` — fetch all records
- `get<Resource>ById(id)` — fetch single record
- `create<Resource>(data)` — insert new record
- `update<Resource>(id, data)` — update existing record
- `delete<Resource>(id)` — delete record

If using SQL, include table creation (IF NOT EXISTS). If using an ORM, define the model/schema.

### Routes / Controller Layer

Add RESTful routes:
- `GET /api/<resource>` — list all
- `GET /api/<resource>/:id` — get by ID
- `POST /api/<resource>` — create
- `PUT /api/<resource>/:id` — update
- `DELETE /api/<resource>/:id` — delete

Include appropriate status codes and error handling matching the project's existing pattern.

### Tests

Add tests for all CRUD operations following the project's existing test style:
- Happy path for each route
- 404 for unknown ID (get, update, delete)
- Validation errors for missing required fields (create, update)

## Step 5: Apply the Changes

Edit the relevant files directly. Do not create separate files unless the project uses one-file-per-resource patterns.

After applying changes, summarize what was added:
- Which files were modified
- What routes are now available
- How to test them (e.g., `curl` examples or test command)
