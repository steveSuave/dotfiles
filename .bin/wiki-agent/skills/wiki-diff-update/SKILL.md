---
name: wiki-diff-update
description: Use when the user asks to update the wiki based on a git diff — typically after code has moved forward since the last ingest. Defines how to compare commits, identify semantic changes, and update affected pages.
---

# Wiki diff-update workflow

Use this when the codebase has changed since the last wiki update and the user wants the wiki brought into sync.

## Step 1 — Identify the two commits

- **Previous commit**: read the most recent entry in `wiki/log.md` that has a git commit hash.
- **Current commit**: ask the user, or use `git rev-parse HEAD` if they didn't specify.

Confirm both with the user before proceeding, especially if the previous commit is far behind — they may want to do this in stages.

## Step 2 — Get the diff

Run:

```
git diff <previous>..<current> --stat
git diff <previous>..<current>
```

The `--stat` first gives you a sense of scope. If the diff is enormous, propose breaking the update into multiple passes (e.g., by package) and ask the user how they want to proceed.

## Step 3 — Classify changes

For each changed file, decide which bucket it falls into:

- **Modified class with semantic change** — business logic, validation, state transitions, or contracts changed. Affects existing wiki pages.
- **New class** — may warrant a new page, or may fold into an existing page.
- **Deleted class** — mark related concept as deprecated or remove the page; update inbound links.
- **Renamed / moved class** — update `Source` paths in affected pages; rename pages if the concept's name changed.
- **Trivial** — formatting, comments, imports, test-only changes, dependency bumps. **Ignore for wiki purposes.** The wiki tracks behavior, not commits.

Be explicit about this classification when discussing with the user — they may flag something you wrote off as trivial that actually matters.

## Step 4 — Discuss before writing

Present:

- The set of files in each bucket.
- For each semantically significant change: which page(s) it affects and what the proposed update is.
- Any new pages you'd create and what they cover.
- Any pages you'd deprecate or delete.
- Any updates to relationships (`Depends on` / `Used by` / `Emits` / `Listens to`) on pages other than the directly-changed ones — relationship changes often ripple.

Wait for confirmation.

## Step 5 — Update pages

For each affected page:

- Update the relevant section (usually `Behavior / Business Logic`, sometimes `Interactions` or `Data Flow`).
- Bump the `last_updated` and `git_commit` frontmatter fields.
- If the change corrects a previous interpretation, add a note under `Notes` calling out what changed and when. Don't erase history silently.
- For renames: update both the page filename and all inbound `[[links]]` (use `Grep` to find them).
- For deletions: prefer leaving the page as a stub with a `**Status: removed in <commit>**` line and a brief explanation, unless the user prefers deletion. Stubs preserve traceability.

## Step 6 — Update index and relationships

- `wiki/index.md`: add new pages, remove deleted ones, move pages between sections if their classification changed.
- Walk the `Used by` lines on adjacent pages — when a caller changes, the callee's "Used by" may also need updating.

## Step 7 — Log

Add the new entry at the **very end** of `wiki/log.md`, never under the header at the top. The log is read in strict chronological (oldest→newest) order, so new entries belong last. Anchor your Edit on the final entry's closing text and add the block after it.

Add to `wiki/log.md`:

```
## YYYY-MM-DD — diff-update

- **Operation**: diff-update
- **Previous commit**: <hash>
- **Current commit**: <hash>
- **Pages created**: [[...]]
- **Pages updated**: [[...]]
- **Pages deprecated/removed**: [[...]]
- **Summary**: one paragraph — what changed semantically and how the wiki was brought into sync.
```

## Step 8 — Report

Summarize for the user:

- What changed in the wiki.
- What you classified as trivial and skipped (in case they want to reconsider).
- Any new unresolved `[[links]]` that might warrant a follow-up ingest.

## Anti-patterns to avoid

- Treating every file change as a wiki change. Most diffs are noise.
- Updating a page without bumping the `last_updated` and `git_commit` frontmatter fields.
- Silently rewriting a page when the business rule itself changed — note the change under `Notes`.
- Leaving dangling `[[links]]` after a rename. Always grep.
- Forgetting that relationship changes are bidirectional (updating "depends on" without checking "used by" on the other end).
