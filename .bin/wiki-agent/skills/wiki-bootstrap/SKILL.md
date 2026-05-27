---
name: wiki-bootstrap
description: Use when the wiki is empty, missing, or only partially built and the user wants to start (or resume) documenting the whole codebase. Inventories the code's packages/modules, measures their size, and writes a sized, ordered ingest plan (wiki/plan.md) so the codebase can be ingested progressively — a slice of a package, one package, or several small packages at a time depending on size.
---

# Wiki bootstrap

Use this to turn a fresh or half-finished wiki into a concrete, resumable plan. The output is `wiki/plan.md`: an ordered checklist of right-sized ingest tasks. You do **not** ingest code here — bootstrapping produces the map; `wiki-ingest` walks it.

Invoke this skill when:

- `wiki/` doesn't exist, or contains only `index.md`/`log.md` with no real pages.
- The user says "bootstrap the wiki", "document the whole codebase", "plan the ingest", "what's left to ingest", or "where were we".
- A `wiki/plan.md` already exists and the user wants to resume — skip to **Step 6 (Resume)**.

## Step 0 — Decide whether a plan already exists

Check for `wiki/plan.md`.

- **Exists** → don't regenerate blindly. Go to **Step 6 (Resume)**: report progress and propose the next task. Only regenerate (Steps 1–5) if the user explicitly asks to re-plan, or if the code's package layout has clearly drifted from the plan.
- **Missing** → continue to Step 1. Create `wiki/`, `wiki/index.md`, and `wiki/log.md` if they don't exist yet.

## Step 1 — Detect the project shape

Identify the language and build system so you enumerate the right unit of code. The unit you plan around is the **package / module** (or its nearest equivalent), not individual files.

| Ecosystem | Source root(s) | Unit to inventory |
|---|---|---|
| Java / Kotlin (Maven, Gradle) | `src/main/java`, `src/main/kotlin`, per-module | Java package = leaf directory of `.java`/`.kt` files |
| TypeScript / JavaScript | `src/`, `packages/*` (monorepo) | Directory / workspace package / feature folder |
| Python | the importable package root | Python package = directory with `__init__.py`; else top-level module dir |
| Go | module root | Go package = directory of `.go` files |
| C# / .NET | per-project `.csproj` | Namespace / project folder |
| Other | `src/` or repo root | Top-level source directories |

Look for multi-module builds (`settings.gradle`, parent `pom.xml` with `<modules>`, npm/pnpm workspaces, a Go workspace). In a multi-module repo, plan **module by module** and inventory packages within each.

## Step 2 — Inventory and size every unit

For each package/module, capture two numbers: a **file count** and a **line count**. These drive batching. Adjust the commands to the detected ecosystem.

Java packages (leaf directories holding source files), with per-package line counts:

```bash
# list leaf source directories (= packages) under a Java source root
find src/main/java -name '*.java' | sed 's#/[^/]*$##' | sort -u

# size each: <files> <lines> <package-dir>
for d in $(find src/main/java -name '*.java' | sed 's#/[^/]*$##' | sort -u); do
  printf '%s\t%s\t%s\n' \
    "$(find "$d" -maxdepth 1 -name '*.java' | wc -l | tr -d ' ')" \
    "$(cat "$d"/*.java 2>/dev/null | wc -l | tr -d ' ')" \
    "$d"
done | sort -k2 -n -r
```

Generic fallback (any language — count files and lines per directory):

```bash
# per-directory line totals, largest first; swap the -name globs per language
find src -name '*.java' -o -name '*.kt' -o -name '*.ts' -o -name '*.py' -o -name '*.go' \
  | sed 's#/[^/]*$##' | sort | uniq -c
```

Record, per unit: relative path, file count, line count, and a one-line guess at its role (domain, service, controller, repository, config, util, …) inferred from the directory name and a quick glance. Don't read every file yet — this is a survey, not an ingest.

## Step 3 — Size into ingest tasks

The goal is tasks that each fit comfortably in **one** ingest pass — enough to read every file in the scope, build a mental model, discuss, and write pages, without the scope being so large that understanding degrades. Use line count as the primary signal, file count as a secondary check.

Rough per-task budget (tune to the codebase; state your chosen budget in the plan):

| Unit size | How to plan it |
|---|---|
| **Small** (≲ 400 LOC and ≲ ~8 files) | **Batch** several cohesive small packages into one task. Group by relationship (same bounded context / sibling packages), not just to hit a number. |
| **Medium** (~400–1500 LOC) | **One package = one task.** The common case. |
| **Large** (≳ 1500 LOC or ≳ ~25 files) | **Split** into sub-tasks: by sub-package if any exist, otherwise by logical cluster (e.g. "order entities", "order state machine", "order events"). Note the intended split in the task so the ingest pass knows the boundary. |

Guidelines:

- Never let a single task span unrelated concerns just to balance size — cohesion beats even batching.
- A package that's huge because it's a dumping ground may be telling you it should become several wiki pages anyway; reflect that in the split.
- Generated code, vendored code, and test directories are normally **excluded** — list them under "Out of scope" rather than as tasks, and confirm with the user.

## Step 4 — Order the tasks

Order so that concept-defining packages come first and later packages can `[[link]]` rather than redefine.

- **Java / Spring / layered / hexagonal / CQRS codebases** → load the `spring-ingestion-order` skill and follow its domain-first ordering (shared kernel → domain → repository → service → controller → DTO → security → config). Apply that ordering across your sized tasks.
- **Other codebases** → apply the same principle generically: foundational/shared types and core domain first; entry points (HTTP handlers, CLI, UI), adapters, and config last; cross-cutting concerns (events, errors, shared utils) added opportunistically once referenced.

Number the tasks in the order you'd execute them.

## Step 5 — Write `wiki/plan.md`

Run `git rev-parse HEAD` (or ask the user for the hash if git is unavailable) and record it as the commit the inventory was taken at. Then write the plan as a checklist of tasks. Use this format:

```markdown
# Wiki ingestion plan

- **Created at commit**: <hash>
- **Source root(s)**: src/main/java
- **Per-task budget**: ~1500 LOC / pass (batch below ~400, split above ~1500)
- **Status**: 3 of 18 tasks complete

> Checklist of ingest tasks in execution order. Check a box only after the
> corresponding `wiki-ingest` pass is logged in `wiki/log.md`. This file is the
> resumable map of the whole codebase; keep it in sync as the plan evolves.

## Tasks

- [x] **1. Shared kernel** — `src/main/java/com/example/common` (6 files, 320 LOC) → [[money-and-currency]], [[base-events]]
- [x] **2. Order domain** — `src/main/java/com/example/order/domain` (14 files, 1180 LOC) → [[order]], [[order-line]]
- [ ] **3. Order persistence** — `src/main/java/com/example/order/repository` (5 files, 410 LOC)
- [ ] **4. Billing — split A: invoices** — `.../billing` invoice classes (~900 LOC of 2600) — large package, ingest in 3 slices
- [ ] **5. Billing — split B: payment processing** — `.../billing` payment classes (~1000 LOC)
- [ ] **6. Small adapters (batched)** — `.../notification`, `.../audit` (3 + 4 files, 280 LOC total) — cohesive, ingest together
- ...

## Out of scope

- `src/test/**` — tests
- `src/main/java/com/example/generated/**` — generated code
- `build/`, `target/` — build output

## Notes

- Hexagonal layout detected: application/use-case layer ingested before adapters (see [[spring-ingestion-order]] variant).
- Re-run bootstrap re-planning if new modules appear.
```

Each task line carries: number, short title, scope path(s), size (files/LOC), and — once done — the pages it produced. Keep tasks small enough that "check the box" is an honest claim after one ingest.

## Step 6 — Resume (when `wiki/plan.md` already exists)

1. Read `wiki/plan.md` and count `[x]` vs `[ ]`.
2. Cross-check against `wiki/log.md`: every checked task should have a matching `ingest` entry. Flag any drift (checked but no log entry, or logged but unchecked).
3. Report progress to the user: "N of M tasks done; next up is task K — `<scope>` (~L LOC)."
4. Propose the next unchecked task as the scope for `wiki-ingest`, and hand off once they confirm. Don't auto-ingest several tasks without checking in.

## Step 7 — Discuss before committing to the plan

Bootstrapping is a proposal, like everything else this agent does. After writing (or before, if the survey was quick) present to the user:

- The chosen per-task budget and why.
- The task count and the first few tasks in order.
- Anything you batched or split, and the reasoning.
- What you put out of scope.

Let them adjust the budget, reorder, or re-scope before any ingestion starts. Then hand off the first task to `wiki-ingest`.

## Keeping the plan honest

- The plan is **edited as you go**, not frozen. When an ingest reveals the layout differs from the survey (a package was bigger than its line count suggested, a split boundary was wrong), update the affected task lines and the `Status` count.
- After each `wiki-ingest` pass completes and is logged, tick its box and append the pages it produced to the task line.
- If the codebase grows new top-level packages later, add tasks for them rather than silently ignoring them — a `wiki-lint` "missing components" finding is the usual trigger.

## Anti-patterns to avoid

- Reading every file during bootstrap. This is a survey; sizing comes from counts, not full reads.
- Producing one giant "ingest everything" task. The whole point is right-sized, resumable slices.
- Batching unrelated packages just to hit the line budget. Cohesion first.
- Letting the plan and `wiki/log.md` drift apart. They must agree on what's done.
- Ingesting without a plan in a large codebase — you lose the thread of what's left.
