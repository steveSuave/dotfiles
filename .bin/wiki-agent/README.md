# wiki-agent — centralized source for the wiki maintainer

This directory is the **single canonical source** for the code-wiki maintainer
agent and its skills, kept centrally in `~/.bin/wiki-agent/` so it can be reused
across every project rather than copied into each repo.

The agent runs on two platforms with slightly different conventions:

- **Claude Code** — reads `.claude/agents/` and `.claude/skills/`
- **GitHub Copilot** — reads `.github/agents/` and `.github/skills/`

The skill bodies are identical across both; only the agent frontmatter differs
(`tools:` for Claude Code, an explicit `skills:` list for Copilot). Rather than
maintain drifting copies per project, both platforms' files are **generated**
from here into whichever project you point the sync script at.

## Layout

```
~/.bin/wiki-agent/
  agent.body.md          shared agent prompt (markdown, no frontmatter)
  skills/<name>/SKILL.md  shared, platform-agnostic skill bodies
  sync.sh                generator (takes a target project path)
  README.md              this file
~/.bin/wiki-sync          launcher on PATH that calls sync.sh
```

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

1. Edit `agent.body.md` or a file under `skills/` here in `~/.bin/wiki-agent/`.
   **Never edit the generated files** under a project's `.claude/` or `.github/`
   directly — `sync.sh` overwrites them.
2. Run `wiki-sync <project>` for each project you want to bring up to date.
3. Commit the regenerated outputs in each project.

To add a skill: create `skills/<name>/SKILL.md`, add `<name>` to the `SKILLS`
array in `sync.sh` (order is the routing order), and re-run sync.

## CI guard

`wiki-sync <project> --check` exits non-zero if any generated file in that
project is out of date with the canonical source. Wire it into CI or a
pre-commit hook to stop the copies from drifting.
