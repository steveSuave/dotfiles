#!/usr/bin/env bash
#
# Generate the Claude Code and GitHub Copilot wiki-maintainer agent + skills
# into a target project, from the single canonical source that lives alongside
# this script (in ~/.bin/wiki-agent/).
#
# Canonical source (edit these, never the generated files):
#   <this dir>/agent.body.md          shared agent prompt body (no frontmatter)
#   <this dir>/skills/<name>/SKILL.md  shared, platform-agnostic skill bodies
#
# Generated outputs, written under the TARGET PROJECT (do not edit by hand):
#   <project>/.claude/agents/code-wiki-maintainer.md
#   <project>/.claude/skills/<name>/SKILL.md
#   <project>/.github/agents/wiki-maintainer.agent.md
#   <project>/.github/skills/<name>/SKILL.md
#
# Usage:
#   sync.sh <project-path>            regenerate all outputs in <project-path>
#   sync.sh <project-path> --check    fail (exit 1) if outputs are stale; write nothing
#   sync.sh --check <project-path>    (flag order does not matter)
#   sync.sh                           defaults <project-path> to the current directory
#
set -euo pipefail

# --- Resolve canonical source (this script's own directory) ------------------
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BODY="$SRC/agent.body.md"
SKILLS_SRC="$SRC/skills"

# --- Parse args: an optional --check flag and an optional project path -------
CHECK=0
PROJECT=""
for arg in "$@"; do
  case "$arg" in
    --check) CHECK=1 ;;
    -h|--help)
      sed -n '2,25p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    -*)
      echo "ERROR: unknown flag: $arg" >&2
      exit 2
      ;;
    *)
      if [[ -n "$PROJECT" ]]; then
        echo "ERROR: more than one project path given: '$PROJECT' and '$arg'" >&2
        exit 2
      fi
      PROJECT="$arg"
      ;;
  esac
done

# Default the project path to the current working directory.
PROJECT="${PROJECT:-$PWD}"

if [[ ! -d "$PROJECT" ]]; then
  echo "ERROR: project path is not a directory: $PROJECT" >&2
  exit 2
fi
PROJECT="$(cd "$PROJECT" && pwd)"  # normalize to absolute

if [[ ! -f "$BODY" ]]; then
  echo "ERROR: canonical agent body missing: $BODY" >&2
  exit 2
fi

# Shared description used in both agents' frontmatter.
DESCRIPTION="Maintains a structured knowledge base (wiki/) that documents the business logic, architecture, and behavior of a software codebase. Invoke when the user asks to ingest a codebase or package, update the wiki from a git diff, lint/audit the wiki, or answer questions about the codebase based on the wiki."

# Skill directory names, in routing order. Drives both the copy step and the
# Copilot agent's `skills:` frontmatter list.
SKILLS=(wiki-bootstrap wiki-ingest wiki-diff-update wiki-lint wiki-page-format spring-ingestion-order)

STALE=0
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# emit <target-path> < generated-content-on-stdin
# In normal mode, writes the file. In --check mode, diffs against the existing
# file and records staleness instead of writing.
emit() {
  local target="$1"
  local staged="$TMP/staged"
  cat > "$staged"
  if [[ "$CHECK" == "1" ]]; then
    if ! diff -q "$target" "$staged" >/dev/null 2>&1; then
      echo "STALE: ${target#$PROJECT/}"
      STALE=1
    fi
  else
    mkdir -p "$(dirname "$target")"
    cp "$staged" "$target"
    echo "wrote: ${target#$PROJECT/}"
  fi
}

echo "source : $SRC"
echo "project: $PROJECT"

# --- Claude Code agent: .claude/agents/code-wiki-maintainer.md ---------------
{
  printf -- '---\n'
  printf 'name: code-wiki-maintainer\n'
  printf 'description: %s\n' "$DESCRIPTION"
  printf 'tools: Read, Write, Edit, Glob, Grep, Bash\n'
  printf -- '---\n\n'
  cat "$BODY"
} | emit "$PROJECT/.claude/agents/code-wiki-maintainer.md"

# --- Copilot agent: .github/agents/wiki-maintainer.agent.md ------------------
{
  printf -- '---\n'
  printf 'name: wiki-maintainer\n'
  printf 'description: %s\n' "$DESCRIPTION"
  printf 'skills:\n'
  for s in "${SKILLS[@]}"; do
    printf '   - skills/%s/SKILL.md\n' "$s"
  done
  printf -- '---\n\n'
  cat "$BODY"
} | emit "$PROJECT/.github/agents/wiki-maintainer.agent.md"

# --- Skills: copied verbatim to both platforms ------------------------------
for s in "${SKILLS[@]}"; do
  src="$SKILLS_SRC/$s/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "ERROR: canonical skill missing: $src" >&2
    exit 2
  fi
  emit "$PROJECT/.claude/skills/$s/SKILL.md" < "$src"
  emit "$PROJECT/.github/skills/$s/SKILL.md" < "$src"
done

if [[ "$CHECK" == "1" && "$STALE" == "1" ]]; then
  echo ""
  echo "Generated agent/skill files are out of date. Run: wiki-sync $PROJECT" >&2
  exit 1
fi

if [[ "$CHECK" == "1" ]]; then
  echo "OK: generated files are in sync with the canonical source."
fi
