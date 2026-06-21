#!/usr/bin/env python3
"""
Stop-hook for Claude Code.

Claude Code calls this each time a turn finishes, passing the hook event as JSON
on stdin. We pull `transcript_path` out of that, read the session's JSONL
transcript, and rewrite ./web/latest.md with the conversation so the browser
page can re-render it (math included).

This is regenerated in full on every turn, so it's idempotent — no appending,
no stale state.
"""

import sys
import os
import json
from pathlib import Path

# ---- toggles -------------------------------------------------------------
FULL_TRANSCRIPT = True   # False -> show only the most recent assistant reply
SHOW_USER = True         # False -> hide your own prompts, show only Claude
# -------------------------------------------------------------------------

OUT = Path(__file__).resolve().parent / "web" / "latest.md"

# User "messages" in the transcript also carry tool results and injected
# context wrapped in tags. Skip blocks that begin with any of these.
SKIP_PREFIXES = (
    "<command-name>", "<command-message>", "<command-args>",
    "<local-command", "<system-reminder", "<bash-",
)


def read_event():
    try:
        return json.load(sys.stdin)
    except Exception:
        return {}


def extract_text(content):
    """content may be a plain string or a list of typed blocks."""
    if isinstance(content, str):
        return content.strip()
    parts = []
    if isinstance(content, list):
        for block in content:
            if not isinstance(block, dict):
                continue
            if block.get("type") == "text" and isinstance(block.get("text"), str):
                parts.append(block["text"])
            # tool_use / tool_result / thinking blocks are intentionally dropped
    return "\n".join(parts).strip()


def looks_like_noise(text):
    return any(text.startswith(p) for p in SKIP_PREFIXES)


def main():
    event = read_event()
    tpath = event.get("transcript_path")
    if not tpath or not os.path.exists(tpath):
        return

    turns = []  # list of (role, text)
    with open(tpath, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
            except Exception:
                continue

            role = entry.get("type") or entry.get("role")
            msg = entry.get("message")
            if isinstance(msg, dict):
                role = msg.get("role", role)
                content = msg.get("content")
            else:
                content = entry.get("content")
            if content is None:
                continue

            text = extract_text(content)
            if not text or looks_like_noise(text):
                continue

            if role == "assistant":
                turns.append(("assistant", text))
            elif role == "user" and SHOW_USER:
                turns.append(("user", text))

    if not FULL_TRANSCRIPT:
        assistant_turns = [t for t in turns if t[0] == "assistant"]
        turns = assistant_turns[-1:] if assistant_turns else []

    chunks = []
    for role, text in turns:
        header = "## You" if role == "user" else "## Claude"
        chunks.append(f"{header}\n\n{text}\n")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n\n---\n\n".join(chunks), encoding="utf-8")


if __name__ == "__main__":
    main()
