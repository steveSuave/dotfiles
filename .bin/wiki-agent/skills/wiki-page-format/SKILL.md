---
name: wiki-page-format
description: Use whenever about to create or edit a page under wiki/. Defines the required page structure (frontmatter schema + section skeleton) and the concrete style rules a page must follow.
---

# Wiki page format

Read this once at the start of a write batch — the structure below should be fresh before you create or update pages.

## Page granularity

One page per major class, concept, or business process — not one per file. Group small related types into a single conceptual page when it improves clarity (e.g., `Money` + `Currency` → `money-and-currency.md`). Filenames are lowercase, hyphen-separated.

## Required structure

Every page opens with a YAML frontmatter block, immediately followed by the title heading. Use this skeleton:

```markdown
---
summary: "One to two sentences describing the role of this component."
type: "class | service | controller | repository | domain concept | process | aggregate | value object | configuration | other"
source: "File(s) or package(s) this page is derived from. Use repo-relative paths."
last_updated: "YYYY-MM-DD"
git_commit: "<hash>"
---

# <Title in Title Case>

## Responsibilities

Bullet list of what this component is responsible for. Each bullet should be a *capability* or *obligation*, not a method name.

## Behavior / Business Logic

Plain-language explanation of the important logic. Cover validation rules, state transitions (a small table/list if there are several), decision points and the business reasons behind them, and invariants the component enforces.

## Interactions

- **Depends on**: [[other-component]], [[another-component]]
- **Used by**: [[caller-1]], [[caller-2]]
- **Emits / publishes**: [[event-name]] (if applicable)
- **Listens to**: [[event-name]] (if applicable)

## Data Flow

Inputs, outputs, and transformations. For services this is often: "Accepts X DTO, loads Y aggregate via [[y-repository]], applies rule Z, persists, returns W."

## Notes

Edge cases, assumptions, surprising behavior, known limitations, deprecations.

## Related pages

- [[related-1]]
- [[related-2]]
```

Two rules on this structure:

- **Omit sections only when genuinely not applicable** (a pure value object has no "Data Flow"). Don't pad with empty headers.
- **The frontmatter is the only metadata block** — don't repeat `**Summary**`/`**Type**` as bold lines in the body. Quote every value with double quotes (summaries contain colons, em-dashes, and `[[links]]` that would otherwise break YAML), escaping any literal `"` inside the value.

## Style rules

- **Name business rules explicitly.** "An order cannot be cancelled after it has shipped" beats "the `cancel()` method checks `status`."
- **Prose for behavior, bullets for responsibilities and interactions.**
- **No code dumps.** A snippet longer than ~8 lines means you're describing implementation, not behavior. Keep any snippet short and labelled illustrative.
- **Mark uncertainty.** If you inferred a business rule rather than reading it stated, say so: "(inferred from usage in `OrderService.cancel`)".

## When updating an existing page

Bump `last_updated` and `git_commit`. If a previous interpretation was wrong, add a brief note under `Notes` rather than silently rewriting — diff-updates rely on understanding what changed. If you rename a page, grep the wiki and fix inbound `[[links]]`.
