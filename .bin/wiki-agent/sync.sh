#!/usr/bin/env bash
#
# Generate the Claude Code and GitHub Copilot wiki agents + skills into a target
# project, from the single canonical source that lives alongside this script (in
# ~/.bin/wiki-agent/). Two agents are generated: the wiki *maintainer* (builds
# and keeps the wiki) and the onboarding *guide* (teaches a newcomer from it).
#
# Canonical source (edit these, never the generated files):
#   <this dir>/agent.body.md           maintainer agent prompt body (no frontmatter)
#   <this dir>/onboard.body.md         onboarding-guide agent prompt body (no frontmatter)
#   <this dir>/skills/<name>/SKILL.md   shared, platform-agnostic skill bodies
#
# Generated outputs, written under the TARGET PROJECT (do not edit by hand):
#   <project>/.claude/agents/code-wiki-maintainer.md
#   <project>/.claude/agents/wiki-onboarding-guide.md
#   <project>/.claude/skills/<name>/SKILL.md
#   <project>/.github/agents/wiki-maintainer.agent.md
#   <project>/.github/agents/wiki-onboarding-guide.agent.md
#   <project>/.github/skills/<name>/SKILL.md
#
# Side effect (write mode only): the generated files above and the <project>/wiki/
# and <project>/onboarding/ trees are added to <project>/.git/info/exclude so they
# stay untracked locally without touching the project's committed .gitignore.
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
GUIDE_BODY="$SRC/onboard.body.md"
SKILLS_SRC="$SRC/skills"

# --- Parse args: an optional --check flag and an optional project path -------
CHECK=0
PROJECT=""
for arg in "$@"; do
  case "$arg" in
    --check) CHECK=1 ;;
    -h|--help)
      sed -n '2,29p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
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

if [[ ! -f "$GUIDE_BODY" ]]; then
  echo "ERROR: canonical onboarding-guide body missing: $GUIDE_BODY" >&2
  exit 2
fi

# Descriptions used in the agents' frontmatter.
DESCRIPTION="Maintains a structured knowledge base (wiki/) that documents the business logic, architecture, and behavior of a software codebase. Invoke when the user asks to ingest a codebase or package, update the wiki from a git diff, lint/audit the wiki, or answer questions about the codebase based on the wiki."
GUIDE_DESCRIPTION="Onboards a developer who is new to the codebase by teaching from the existing wiki/ knowledge base in a learner-paced order. Invoke when someone says they're new, asks to be walked through the code, asks where to start, or wants to continue onboarding. Reads the wiki (and src as a fallback); writes only per-learner progress notes under onboarding/."

# Skill directory names, in routing order. The maintainer and the onboarding
# guide are separate agents with separate skill sets; ALL_SKILLS is their union
# and drives the copy step + the EXCLUDES list.
MAINTAINER_SKILLS=(wiki-bootstrap wiki-ingest wiki-diff-update wiki-lint wiki-page-format spring-ingestion-order)
GUIDE_SKILLS=(wiki-onboard)
ALL_SKILLS=("${MAINTAINER_SKILLS[@]}" "${GUIDE_SKILLS[@]}")

# Project-relative paths of everything generated here, plus the wiki content
# itself. These are added to the target project's .git/info/exclude so they stay
# out of `git status` without touching the project's tracked .gitignore. Paths
# are anchored (leading "/") to the repo root; directories carry a trailing "/".
EXCLUDES=(
  "/.claude/agents/code-wiki-maintainer.md"
  "/.claude/agents/wiki-onboarding-guide.md"
  "/.github/agents/wiki-maintainer.agent.md"
  "/.github/agents/wiki-onboarding-guide.agent.md"
  "/wiki/"
  "/onboarding/"
)
for s in "${ALL_SKILLS[@]}"; do
  EXCLUDES+=("/.claude/skills/$s/" "/.github/skills/$s/")
done

# Markers delimiting the block this script manages inside .git/info/exclude.
EXCL_BEGIN="# >>> wiki-agent (managed by wiki-sync) >>>"
EXCL_END="# <<< wiki-agent (managed by wiki-sync) <<<"

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

# add_git_exclude — locally ignore the generated files (+ the wiki) in the
# target repo, idempotently. Rewrites a marker-delimited block in
# .git/info/exclude, preserving the user's own entries. No-op if not a git repo.
add_git_exclude() {
  local git_dir exclude staged
  if [[ -d "$PROJECT/.git" ]]; then
    git_dir="$PROJECT/.git"
  elif [[ -f "$PROJECT/.git" ]]; then
    # Worktree or submodule: .git is a file of the form "gitdir: <path>".
    git_dir="$(sed -n 's/^gitdir: //p' "$PROJECT/.git" | head -n1)"
    [[ -n "$git_dir" && "$git_dir" != /* ]] && git_dir="$PROJECT/$git_dir"
  fi
  if [[ -z "${git_dir:-}" || ! -d "$git_dir" ]]; then
    echo "note   : $PROJECT is not a git repo; skipped .git/info/exclude"
    return 0
  fi

  exclude="$git_dir/info/exclude"
  staged="$TMP/exclude"
  mkdir -p "$git_dir/info"

  # Carry over any pre-existing content, stripping a previous managed block.
  if [[ -f "$exclude" ]]; then
    awk -v b="$EXCL_BEGIN" -v e="$EXCL_END" '
      $0 == b { skip = 1 }
      !skip   { print }
      $0 == e { skip = 0 }
    ' "$exclude" > "$staged"
  else
    : > "$staged"
  fi

  # Append a fresh managed block.
  {
    printf '%s\n' "$EXCL_BEGIN"
    printf '# Generated wiki agents + skills, and the wiki/ and onboarding/ trees.\n'
    printf '# Rewritten by wiki-sync on each run; do not edit between markers.\n'
    printf '%s\n' "${EXCLUDES[@]}"
    printf '%s\n' "$EXCL_END"
  } >> "$staged"

  cp "$staged" "$exclude"
  echo "wrote  : ${exclude#$PROJECT/} (${#EXCLUDES[@]} wiki entries)"
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
  for s in "${MAINTAINER_SKILLS[@]}"; do
    printf '   - skills/%s/SKILL.md\n' "$s"
  done
  printf -- '---\n\n'
  cat "$BODY"
} | emit "$PROJECT/.github/agents/wiki-maintainer.agent.md"

# --- Claude Code agent: .claude/agents/wiki-onboarding-guide.md --------------
{
  printf -- '---\n'
  printf 'name: wiki-onboarding-guide\n'
  printf 'description: %s\n' "$GUIDE_DESCRIPTION"
  printf 'tools: Read, Write, Edit, Glob, Grep, Bash\n'
  printf -- '---\n\n'
  cat "$GUIDE_BODY"
} | emit "$PROJECT/.claude/agents/wiki-onboarding-guide.md"

# --- Copilot agent: .github/agents/wiki-onboarding-guide.agent.md ------------
{
  printf -- '---\n'
  printf 'name: wiki-onboarding-guide\n'
  printf 'description: %s\n' "$GUIDE_DESCRIPTION"
  printf 'skills:\n'
  for s in "${GUIDE_SKILLS[@]}"; do
    printf '   - skills/%s/SKILL.md\n' "$s"
  done
  printf -- '---\n\n'
  cat "$GUIDE_BODY"
} | emit "$PROJECT/.github/agents/wiki-onboarding-guide.agent.md"

# --- Skills: copied verbatim to both platforms ------------------------------
for s in "${ALL_SKILLS[@]}"; do
  src="$SKILLS_SRC/$s/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "ERROR: canonical skill missing: $src" >&2
    exit 2
  fi
  emit "$PROJECT/.claude/skills/$s/SKILL.md" < "$src"
  emit "$PROJECT/.github/skills/$s/SKILL.md" < "$src"
done

# Keep the generated files + wiki out of the target repo's `git status`.
# Skipped in --check mode, which writes nothing.
if [[ "$CHECK" == "0" ]]; then
  add_git_exclude
fi

if [[ "$CHECK" == "1" && "$STALE" == "1" ]]; then
  echo ""
  echo "Generated agent/skill files are out of date. Run: wiki-sync $PROJECT" >&2
  exit 1
fi

if [[ "$CHECK" == "1" ]]; then
  echo "OK: generated files are in sync with the canonical source."
fi
