# File Organization

Applies to any project. Keeps planning artifacts and generated docs version-controlled.

## Plan and Documentation Files

When creating `.md` plan files, QA guides, architecture notes, or any documentation during work:

- **Save to:** `docs/` folder in the project root (create it if it doesn't exist)
- **Never save to:** `~/.claude/` or any location outside the project directory

This ensures all planning artifacts are version-controlled with the codebase and visible to the whole team.

## Temporary Files

Do not create temporary scratch files in the project root. If a temporary file is needed during work, clean it up before finishing the task.

## New Source Files

Place new source files in the directory that matches the existing structure:
- Follow the pattern of sibling files in the same package/module
- Do not create new top-level directories without confirming with the user
