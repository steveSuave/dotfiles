# wiki-agent — centralized source for the wiki agents

This directory is the **single canonical source** for the code-wiki agents and
their skills, kept centrally in `~/.bin/wiki-agent/` so they can be reused across
every project rather than copied into each repo.

Two agents are generated, with complementary jobs:

- **`code-wiki-maintainer`** — *builds and maintains* the `wiki/` knowledge base:
  bootstraps an ingest plan, ingests packages, updates the wiki from a git diff,
  and lints it. It owns `wiki/`.
- **`wiki-onboarding-guide`** — *uses* that wiki to onboard a developer new to
  the codebase, teaching the business logic in a learner-paced order, answering
  questions, and tracking each learner's progress under `onboarding/`. It is
  read-only on `wiki/` and `src/`.

Each agent runs on two platforms with slightly different conventions:

- **Claude Code** — reads `.claude/agents/` and `.claude/skills/`
- **GitHub Copilot** — reads `.github/agents/` and `.github/skills/`

The skill bodies are identical across both; only the agent frontmatter differs
(`tools:` for Claude Code, an explicit `skills:` list for Copilot). Rather than
maintain drifting copies per project, both platforms' files are **generated**
from here into whichever project you point the sync script at.

## Layout

```
~/.bin/wiki-agent/
  agent.body.md           maintainer agent prompt (markdown, no frontmatter)
  onboard.body.md         onboarding-guide agent prompt (markdown, no frontmatter)
  skills/<name>/SKILL.md   shared, platform-agnostic skill bodies
  sync.sh                 generator (takes a target project path)
  README.md               this file
~/.bin/wiki-sync          launcher on PATH that calls sync.sh
```

The maintainer routes to `wiki-bootstrap`, `wiki-ingest`, `wiki-diff-update`,
`wiki-lint`, `wiki-page-format`, and `spring-ingestion-order`. The onboarding
guide routes to `wiki-onboard`. `sync.sh` copies the union of both sets to each
platform; the per-agent skill lists live in the `MAINTAINER_SKILLS` and
`GUIDE_SKILLS` arrays in `sync.sh`.

## Usage

`wiki-sync` (on PATH) takes the **target project path** as its argument and
writes the generated files into that project's `.claude/` and `.github/`:

```bash
wiki-sync /path/to/some-project          # regenerate outputs in that project
wiki-sync                                 # default: current directory
wiki-sync /path/to/some-project --check   # CI guard: exit 1 if outputs are stale
```

You can also call the script directly: `~/.bin/wiki-agent/sync.sh <project>`.

## Editing

1. Edit `agent.body.md`, `onboard.body.md`, or a file under `skills/` here in
   `~/.bin/wiki-agent/`. **Never edit the generated files** under a project's
   `.claude/` or `.github/` directly — `sync.sh` overwrites them.
2. Run `wiki-sync <project>` for each project you want to bring up to date.

To add a skill: create `skills/<name>/SKILL.md`, add `<name>` to the
`MAINTAINER_SKILLS` or `GUIDE_SKILLS` array in `sync.sh` (order is the routing
order for that agent), and re-run sync.

## Local-only by default (`.git/info/exclude`)

These files are generated per-project and shouldn't pollute the target repo's
history, so `wiki-sync` keeps them **untracked locally** rather than asking you
to commit them. On each run (not `--check`) it rewrites a marker-delimited block
in the target project's `.git/info/exclude` listing the generated agent + skill
paths *and* the `wiki/` and `onboarding/` trees:

```
# >>> wiki-agent (managed by wiki-sync) >>>
...
# <<< wiki-agent (managed by wiki-sync) <<<
```

The block is rewritten idempotently, preserving any of your own entries in that
file. `.git/info/exclude` is per-clone and never committed, so each developer
who wants the wiki agent runs `wiki-sync` themselves. If a project would rather
track these files, delete the managed block (or commit the paths with
`git add -f`). Non-git target directories are left untouched.

## CI guard

`wiki-sync <project> --check` exits non-zero if any generated file in that
project is out of date with the canonical source. Wire it into CI or a
pre-commit hook to stop the copies from drifting.
