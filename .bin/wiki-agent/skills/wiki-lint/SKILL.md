---
name: wiki-lint
description: Use when the user asks to lint, audit, or check the health of the wiki. Defines checks for contradictions, outdated pages, orphans, missing components, over-implementation detail, and format compliance.
---

# Wiki lint

Use this when the user asks to audit the wiki. Produce a numbered findings list with concrete suggested fixes — don't fix things silently.

## Checks to run

Work through these in order. For each finding, record: the page(s) involved, the issue, and a suggested fix.

### 1. Format compliance

For every page under `wiki/`:

- A YAML frontmatter block opens the page, followed by the title heading, with the required fields present: `summary`, `type`, `source`, `last_updated`, `git_commit`. Flag pages that still carry the old `**Summary**`/`**Type**` bold-line header instead of frontmatter.
- Required sections present (or justifiably omitted): `Responsibilities`, `Behavior / Business Logic`, `Interactions`, `Data Flow`, `Notes`, `Related pages`.
- File naming: lowercase-hyphenated.

### 2. Contradictions between pages

Look for claims that disagree:

- Same business rule described differently on two pages.
- Conflicting state transitions for the same entity.
- A page claims component A depends on B, but B's page doesn't list A under "Used by".

Bidirectional relationship integrity is the most common issue here — worth a dedicated pass.

### 3. Outdated pages

- Compare each page's `git_commit` frontmatter field against the latest commit in `wiki/log.md`.
- Flag any page whose commit is older than the most recent `ingest` or `diff-update` entry that *should* have touched it. Use `git log <commit>..HEAD -- <source path>` to check whether the page's source files changed since the page was last updated.

### 4. Orphan pages

A page is an orphan if no other page links to it via `[[page-name]]` and it isn't listed in `wiki/index.md`. Use `Grep` across `wiki/` to confirm.

Orphans aren't always wrong (a top-level concept page might intentionally have few inbound links), but flag them so the user can decide.

### 5. Missing components

Scan `src/` and compare against the wiki:

- Identify significant classes, services, or modules in `src/` that are not represented by any wiki page or referenced in any `Source` field.
- Be selective — not every utility class deserves a page. Flag things that look like business concepts, services, or repositories.
- If `wiki/plan.md` exists, cross-check: a missing package that has no plan task is the signal to add a `wiki-bootstrap` task for it (suggest this as the fix), not just to ingest it ad-hoc. A package covered by an unchecked task is simply pending, not missing.

### 6. Over-implementation detail

Read pages and flag any that:

- Contain long code blocks (more than ~8 lines).
- Describe method signatures, field lists, or class hierarchies in a way that mirrors the code rather than the behavior.
- Read like Javadoc rather than business documentation.

The fix is usually: rewrite in plain language focusing on *why* and *what for*, not *how*.

### 7. Business logic clarity

For each service / process / domain page, check that:

- At least one of: validation rules, state transitions, decision points, or invariants is explicitly named.
- The *reason* the logic exists is stated, not just the mechanics.

If a page describes behavior without explaining the business motivation, flag it.

### 8. Broken or dangling links

- Find every `[[link]]` in the wiki via `Grep`.
- Check whether the target page exists.
- Dangling links are acceptable if they represent known future work (a page intended to be created in a later ingest), but they should be reviewed. Group them in the report so the user can sweep them.

### 9. Index health

- Every page should be reachable from `wiki/index.md` (directly or via a chain of links from index pages).
- The index should group by concept (Domain, Services, Repositories, etc.), not be a flat alphabetical dump unless the wiki is very large.

### 10. Log integrity

- Every entry in `wiki/log.md` has a git commit hash.
- Entries are in chronological order.
- No long gaps between ingest entries and the current `HEAD` — if there's significant code change since the last entry, suggest a diff-update.

## Output format

Produce a numbered list. For each finding:

```
N. <Severity: critical | warning | nit> — <one-line summary>
   - Page(s): [[page-a]], [[page-b]]
   - Issue: brief description
   - Suggested fix: concrete action
```

End with a short overall assessment (e.g., "Wiki is broadly healthy but three pages are stale; the order-domain area has the most outstanding issues").

## What lint does NOT do

- Lint reports findings; it does not fix them. Wait for the user to direct any follow-up edits.
- Lint does not re-ingest or re-read entire packages. It works from what's in the wiki plus targeted spot-checks of `src/`.
