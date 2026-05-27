---
name: wiki-ingest
description: Use when the user asks to ingest a scope of the codebase (a package, module, folder, or set of files) into the wiki. Defines the read → discuss → write → log workflow and the rules for incremental ingestion.
---

# Wiki ingest workflow

Use this when the user wants a new portion of the codebase represented in the wiki.

## Step 1 — Establish scope

Confirm what's being ingested before reading anything heavy. Examples of valid scopes:

- A package: `src/com/example/order`
- A folder: `src/services/billing`
- A feature surface: "everything related to subscriptions"

If the scope is fuzzy ("the service layer"), ask which folder(s). Don't guess.

If this is the *first* ingest in the repo, also check whether `wiki/`, `wiki/index.md`, and `wiki/log.md` exist. Create them if not.

If `wiki/plan.md` exists, this ingest should normally correspond to one of its unchecked tasks — confirm which task you're executing and use its scope. If the wiki is empty and there's no plan yet for a non-trivial codebase, prefer running `wiki-bootstrap` first so ingestion is sized and ordered rather than ad-hoc.

If the project looks like a Spring / Java codebase and the user hasn't told you what to ingest first, also consult the `spring-ingestion-order` skill before recommending a starting point.

## Step 2 — Read

- Read **every file** in the scope. Use `Glob` to enumerate, `Read` to ingest.
- Also read any wiki pages that the scope might touch, by scanning `wiki/index.md` first. You need to know what already exists to avoid duplication.
- Note imports/references that point *outside* the scope — these are linking opportunities to existing or future pages.

## Step 3 — Identify

While reading, build a mental model of:

1. **Core entities** — classes, interfaces, types that name business concepts.
2. **Responsibilities** — what each component is *for*, in one sentence.
3. **Business logic** — validation, state transitions, decision points, invariants.
4. **Relationships** — who calls whom, who owns what, who emits/listens.
5. **Cross-cutting touch points** — events, exceptions, shared utilities referenced from multiple places. These often deserve their own pages.

Group related low-level types into higher-level concepts when it improves clarity (e.g., `Money` + `Currency` + `MoneyAmount` → one `money-and-currency` page).

## Step 4 — Discuss before writing

This is mandatory, not optional. Present to the user:

- A short list of pages you intend to **create**, with one-line summaries each.
- A list of pages you intend to **update**, with what will change.
- Any contradictions or corrections vs. existing pages.
- Any cross-cutting concerns you noticed that might warrant their own pages.
- Any open questions where the code is ambiguous and you need their judgement.

Wait for confirmation or redirection. Do not write until the user agrees with the plan.

## Step 5 — Write

After approval, and **after re-reading the `wiki-page-format` skill**, create or update each page.

Rules during writing:

- Follow the page format exactly.
- Use `[[wiki-links]]` for every reference to another component, whether the target page exists yet or not. Unresolved links signal intentional future work.
- Prefer extending an existing page over creating a parallel one.
- If you correct an earlier interpretation, add a short note under `Notes` on the affected page.

## Step 6 — Update the index

Open `wiki/index.md` and:

- Add new pages under the right section.
- Move pages between sections if their classification changed (e.g., something thought to be a service turns out to be a domain process).

## Step 7 — Log

Run `git rev-parse HEAD` to capture the current commit. If the repo isn't a git repo or git isn't available, ask the user for the commit hash.

Append the new entry at the **very end** of `wiki/log.md`, never under the header at the top. The log is read in strict chronological (oldest→newest) order, so new entries belong last. Anchor your Edit on the final entry's closing text and add the block after it.

Add to `wiki/log.md`:

```
## YYYY-MM-DD — ingest

- **Operation**: ingest
- **Scope**: <package or folder>
- **Git commit**: <hash>
- **Pages created**: [[page-a]], [[page-b]]
- **Pages updated**: [[page-c]]
- **Summary**: one paragraph — what was learned, what was changed, any corrections to earlier pages.
```

## Step 8 — Update the plan (if one exists)

If `wiki/plan.md` exists, now that the log entry is written:

- Tick this task's checkbox (`[ ]` → `[x]`) and append the pages it produced to the task line.
- Bump the `Status` count at the top of the plan.
- If reading the scope revealed the plan was wrong (a package larger than its line count suggested, a split boundary that didn't hold, an unlisted sub-package), correct the affected task lines now while it's fresh — add, split, or re-scope tasks. The plan is a living map, not a frozen contract.

## Step 9 — Report back

Tell the user:

- What pages were created and updated.
- Any unresolved `[[links]]` they should be aware of (these are the natural next ingest candidates).
- If a plan exists: progress so far and the next unchecked task.
- Any open questions still on the table.

## Anti-patterns to avoid

- Writing pages before discussing with the user.
- Creating a new page when an existing one could absorb the content.
- Restating method signatures or class field lists. The wiki is not Javadoc.
- Ingesting more scope than the user asked for. Stay in the scope; note adjacent concepts as future work.
- Skipping the log entry. The diff-update workflow depends on it.
