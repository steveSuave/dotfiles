---
name: spring-ingestion-order
description: Use when planning the ingest order for a Spring / Java codebase (or similar layered enterprise project) and the user hasn't specified which package to start with. Recommends a domain-first order and explains why controller-first is the wrong default.
---

# Ingestion order for Spring projects

Use this to recommend a starting point and order when the user wants to ingest a Spring (or similarly layered) codebase but hasn't told you where to begin. Surface this guidance to the user as a *proposal*, not a decree — they may have reasons to do it differently.

## Guiding principle

The wiki's goal is extracting **business logic, behavior, and intent** — not framework plumbing. Order should front-load packages that *anchor meaning* and let later packages enrich them. Define concepts where they live, then let upstream layers link down.

## Step 0 — Shared kernel (if it exists)

Before anything else, ask the user: is there a `core`, `common`, or `shared-kernel` module that other packages depend on? If yes, ingest it first so foundational types (`Money`, `Email`, base events, base exceptions) are already linkable from later pages.

## Step 1 — Domain / model / entity

Start here, **not at controllers**. Entities and value objects encode the ubiquitous language: what an `Order`, `Invoice`, or `Subscription` *is*, what states it can be in, what invariants must hold.

Every later package will reference these concepts. Establishing them first means subsequent pages can `[[link]]` rather than redefine. In DDD-flavored codebases this also surfaces aggregates and domain events early.

## Step 2 — Repository / persistence

Repositories reveal which entities are persisted, how they're queried, and what relationships matter at runtime versus on paper. Custom `@Query` methods and specifications often *are* business rules in disguise ("find active subscriptions expiring in 7 days"). Reading these right after the domain confirms or corrects the initial entity interpretation.

## Step 3 — Service / application

The heart of the wiki. Services orchestrate domain objects, enforce business rules, manage transactions, and define state transitions — the exact things the wiki prioritizes. By this point the `[[order]]` and `[[order-repository]]` pages already exist, so service pages stay conceptual.

## Step 4 — Controller / web / api

Mostly translation layers: HTTP → service call → DTO. Ingesting late means endpoints can be described as "exposes `[[order-service.placeOrder]]` over REST" instead of re-explaining logic. Controllers also reveal the public surface.

## Step 5 — DTO / mapper

Often folded into controller or service pages rather than getting their own. Worth a dedicated pass only if mappers contain non-trivial transformations (computed fields, redaction rules).

## Step 6 — Security / auth

Cross-cutting and best understood once you know what's being protected. Method-level `@PreAuthorize` rules often encode business policy ("only the order owner or an admin can cancel") — these belong in the wiki, but they read more clearly after the domain is mapped.

## Step 7 — Config / infrastructure / messaging adapters

Last, and lightly. Beans, properties, `@Configuration` classes, Kafka listeners, scheduled jobs. Document *what* they wire up and *why* (a nightly job that closes orders older than 30 days is real business logic), but don't waste pages on Spring boilerplate.

## Why not controller-first?

The intuitive "controller → service → repo → domain" order mirrors a *request's* path through the system, which is great for debugging but bad for a knowledge base. You'd write `OrderController` first, find yourself describing what an order is, then rewrite that explanation at the entity layer. The "evolve, don't duplicate" rule pushes against this.

## Caveats to mention to the user

- **Cross-cutting concerns** (events, exceptions, common utilities) usually deserve their own pages once you see them referenced from multiple packages. Add them opportunistically rather than scheduling them up front.
- **Hexagonal / CQRS architectures** — swap steps 2 and 3. Read the application/use-case layer before persistence, since ports define what the domain needs and adapters just satisfy them.
- **Log each package as a separate ingest entry** with its own commit hash. If domain understanding shifts when you reach services, the diff-update workflow has a clean previous state to compare against.

## What to do with this skill

When invoked: propose the order to the user, ask about a shared kernel, and ask whether the architecture is layered, hexagonal, or CQRS so you can recommend the right variant. Then hand off to the `wiki-ingest` skill for whichever scope they pick first.
