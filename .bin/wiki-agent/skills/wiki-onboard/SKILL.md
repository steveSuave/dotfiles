---
name: wiki-onboard
description: Use when a developer new to the codebase wants to be onboarded — "walk me through the code", "I'm new here", "where do I start", "continue onboarding", "where were we". Defines how to build a learner-paced curriculum from the wiki, run an onboarding session one concept at a time, answer questions, and track each learner's progress in onboarding/<name>.md.
---

# Wiki onboarding

Use this to guide a new developer through the codebase using the existing `wiki/` as the curriculum. You teach from the wiki; you do not modify it. The only files you write are per-learner progress notes under `onboarding/`.

## Step 0 — Confirm there is a wiki to teach from

Read `wiki/index.md` and `wiki/log.md`.

- **Empty or missing wiki** (only `index.md`/`log.md`, no real pages) → stop. There is nothing to onboard from. Tell the user the wiki must be built first via the `code-wiki-maintainer` agent / `wiki-bootstrap`, and don't teach from raw `src/`.
- **Partial wiki** → proceed, but note which areas aren't documented yet so you can be honest about the boundaries and log them as follow-ups.
- **Healthy wiki** → continue to Step 1.

Record the commit the wiki reflects: the latest hash in `wiki/log.md`, or `git rev-parse HEAD` if absent.

## Step 1 — Identify the learner and calibrate

Before teaching, find out who you're teaching:

- **Name / handle** — drives the notes filename (`onboarding/<name>.md`). If a file already exists, this is a resume (jump to Step 5).
- **Background** — language/stack familiarity, domain familiarity (do they know *this* business already?), seniority. This sets pacing and depth.
- **Goal and time** — onboarding for general contribution vs. a specific area; how long this session is. A learner with a narrow goal may want to branch off the standard path early.

Keep this short — a couple of questions — then proceed.

## Step 2 — Build the learning path (the ideal newcomer order)

The wiki was *written* domain-first (so pages could link cleanly). A *human* learns best big-picture-inward. Derive a sequenced path from `wiki/index.md`, ordering roughly:

1. **System overview** — what the system does and for whom, the top-level shape. If the wiki has an overview/architecture/README-style page, start there. If not, synthesize a one-paragraph orientation from the index sections and the highest-level pages, and note the missing overview as a follow-up.
2. **Core domain vocabulary** — the handful of entities and value objects that name the ubiquitous language (`[[order]]`, `[[invoice]]`, `[[subscription]]`, money/currency, etc.). The learner needs these words before anything else makes sense. Keep it to the *core* few, not every domain page.
3. **One real end-to-end business flow** — pick the single most representative flow (the system's "happy path": place an order, process a payment, run the nightly job) and trace it across the pages it touches, in the order data actually moves. This is the keystone: it turns the vocabulary into a working mental model. Prefer flow-first over exhaustively touring every service.
4. **Key services / processes** — the services behind that flow and the next most important ones, where the real business rules live (validation, state transitions, decisions, invariants).
5. **Cross-cutting concerns** — events, errors, shared utilities, security/authorization rules — once the learner has things to hang them on.
6. **Infrastructure / config / adapters** — last and lightly: persistence wiring, messaging, scheduled jobs, configuration. Cover what carries business meaning (a nightly close-out job), skip pure plumbing.

Why this order and not the ingestion order: a newcomer who starts at the domain layer learns *nouns* with nothing to do; starting from the overview and an end-to-end flow gives them a spine to attach every later concept to. (The maintainer's domain-first ordering is about clean authoring, not human learning — see `[[spring-ingestion-order]]` for that contrast.)

Adapt to the actual wiki: use the real page names from `wiki/index.md`, and to the learner's goal (a learner who only needs the billing area can take the overview + vocab, then branch straight to billing). Present the proposed path to the learner before diving in, and let them reorder or trim it.

## Step 3 — Write (or update) the progress notes

Create `onboarding/<name>.md` if it doesn't exist. Format:

```markdown
---
learner: "<name or handle>"
background: "one line — stack/domain familiarity, seniority"
goal: "what they're onboarding for"
started: "YYYY-MM-DD"
wiki_commit: "<hash the wiki reflected when we started>"
last_session: "YYYY-MM-DD"
---

# Onboarding — <name>

## Learning path

> Checklist in teaching order. Tick a unit only after it's been covered in a session.

- [x] 1. System overview → [[architecture-overview]]
- [x] 2. Core domain vocabulary → [[order]], [[money-and-currency]]
- [ ] 3. End-to-end flow: placing an order → [[order-service]], [[order-repository]], [[payment]]
- [ ] 4. Billing services → [[invoice-service]], [[payment-service]]
- [ ] 5. Cross-cutting: domain events & errors → [[domain-events]]
- [ ] 6. Infrastructure: scheduled jobs → [[nightly-close-job]]

## Covered

- **YYYY-MM-DD — System overview**: what the system does, the three top-level subsystems, where the learner's team fits.
- **YYYY-MM-DD — Domain vocabulary**: order / line item / money. Learner already knew the domain, moved fast.

## Open questions

- Does cancellation refund automatically, or is it a separate step? (raised while covering the order flow — wiki unclear, see follow-up)

## Follow-ups / wiki gaps found

- No overview page exists; synthesized one verbally. Suggest maintainer add `[[architecture-overview]]`.
- Refund timing not documented on [[payment-service]] — recommend a diff-update or ingest.

## Next up

Unit 3 — trace the place-an-order flow end to end.
```

This file is the learner's resumable map. Keep it honest: tick a unit only once it's genuinely been covered, and keep "Open questions", "Follow-ups", and "Next up" current.

## Step 4 — Run the session (the teaching loop)

For each unit, in order:

1. **Set up** — one sentence on what this unit is and why it comes now ("now that you know what an order *is*, let's watch one get placed").
2. **Teach from the wiki** — read the relevant page(s) and explain in plain language: the responsibilities, the key business rules, and the *why* behind them. Cite pages by name as you go (`[[order-service]]`). Walk `[[links]]` to show how concepts connect.
3. **Relate to the known** — tie it back to units already covered.
4. **Pause** — invite questions. Don't chain three units together; the pause is the point. For a flow unit, optionally ask the learner to predict the next step before you reveal it.
5. **Check understanding** — periodically ask them to restate or apply the concept. Calibrate pace from their answers.
6. **Record** — tick the unit in the notes, add a one-line "Covered" entry (date + what was actually conveyed), and capture any questions or gaps that came up.

Cover one or a few related units per session depending on the learner's time and energy — don't force the whole path in one sitting. End each session by updating "Next up" and `last_session`.

## Step 5 — Resume a returning learner

When the learner says "continue" / "where were we":

1. Read `onboarding/<name>.md`; count covered vs. remaining units.
2. Compare the recorded `wiki_commit` against the latest hash in `wiki/log.md`. If the wiki has advanced, mention what changed in areas they've covered (and offer to revisit if it's material).
3. Report progress ("you've done 1–3 of 6; next is unit 4, the billing services") and resume the loop at the next unticked unit.
4. Revisit any open questions that have since been answered (e.g., the maintainer ingested the gap).

## Answering questions mid-session

- Ground every answer in the wiki and cite the page(s).
- If the wiki covers it, teach it — and if it's ahead of where the learner is on the path, give a short answer now and note that you'll cover it properly later.
- If the wiki *doesn't* cover it: say so, optionally read `src/` for a **provisional** answer (clearly labeled), and log a follow-up / gap. Never present an inferred business rule as established fact.

## Anti-patterns to avoid

- **Teaching from `src/` when the wiki exists.** The wiki is the curriculum; code is the fallback for gaps only.
- **Modifying the wiki or source.** You write `onboarding/` files only. Gaps become follow-ups for the maintainer, not edits you make.
- **Dumping the whole path at once.** Onboarding is paced and interactive; the pauses and comprehension checks are where learning happens.
- **Domain-first, flow-never.** Don't recreate the ingestion order. A newcomer needs the overview and one end-to-end flow early.
- **Skipping the notes.** If you don't record what was covered, you can't resume honestly, and the learner can't see their own progress.
- **Ignoring repeated questions.** The same question from multiple learners is a signal the wiki or the path needs work — log it.
