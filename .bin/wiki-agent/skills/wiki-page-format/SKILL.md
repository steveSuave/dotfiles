---
name: wiki-page-format
description: Use whenever about to create or edit a page under wiki/. Defines the required page structure, naming conventions, linking rules, and style guidance (behavior over syntax, intent over implementation).
---

# Wiki page format

Read this before writing or updating any wiki page.

## File naming

- Lowercase, hyphen-separated. `order-service.md`, not `OrderService.md` or `order_service.md`.
- One page per major class, concept, or business process — not per file.
- Group small related classes into a single conceptual page when it improves clarity (e.g., several value objects → `money-and-currency.md`).

## Required structure

Every page opens with a YAML frontmatter block carrying the metadata, immediately followed by the title heading. Use this skeleton:

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

Plain-language explanation of the important logic. Cover:
- Validation rules
- State transitions (use a small table or list if there are several)
- Decision points and the business reasons behind them
- Invariants the component enforces

Avoid code unless a snippet genuinely clarifies. When you do include code, keep it short and label it as illustrative.

## Interactions

- **Depends on**: [[other-component]], [[another-component]]
- **Used by**: [[caller-1]], [[caller-2]]
- **Emits / publishes**: [[event-name]] (if applicable)
- **Listens to**: [[event-name]] (if applicable)

## Data Flow

Describe inputs, outputs, and transformations. For services, this often means: "Accepts X DTO, loads Y aggregate via [[y-repository]], applies rule Z, persists, returns W."

## Notes

Edge cases, assumptions, surprising behavior, known limitations, deprecations.

## Related pages

- [[related-1]]
- [[related-2]]
```

Sections may be omitted only when genuinely not applicable (e.g., a pure value object has no "Data Flow"). Do not pad with empty headers.

The frontmatter is the only metadata block — do not also repeat `**Summary**`/`**Type**` as bold lines in the body. Quote every value with double quotes (summaries contain colons, em-dashes, and `[[links]]` that would otherwise break YAML), escaping any literal `"` inside the value.

## Style rules

- **Intent first.** Open the Behavior section by saying *why* the component exists before *how* it works.
- **Name business rules explicitly.** "An order cannot be cancelled after it has shipped" is more valuable than "the `cancel()` method checks `status`."
- **Prefer prose over bullets for behavior**, bullets for responsibilities and interactions.
- **Link, don't redefine.** If `[[order]]` exists, link to it instead of re-explaining what an order is.
- **No code dumps.** If a snippet is longer than ~8 lines, you're probably describing implementation, not behavior.
- **Mark uncertainty.** If you inferred a business rule rather than reading it stated, say so: "(inferred from usage in `OrderService.cancel`)".

## Updating an existing page

- Bump the `last_updated` and `git_commit` frontmatter fields whenever you change the page.
- If a previous interpretation was wrong, add a brief note under `Notes` calling out the correction. Don't silently rewrite history — future diff-updates rely on understanding what changed.
- Preserve inbound `[[links]]` to the page. If you rename a page, grep the wiki and update references.

## Updating `wiki/index.md`

After any page creation or significant restructure:

- Add new pages under the appropriate section.
- Keep the index organized by concept (Domain, Services, Repositories, Controllers, Cross-cutting, Processes), not alphabetical, unless the wiki is so large that alphabetical is necessary as a secondary index.
- Each entry links to the page and gives a one-line description.
