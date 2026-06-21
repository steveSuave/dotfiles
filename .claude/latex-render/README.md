# LaTeX rendering for select Claude Code sessions

Runs your usual Claude Code session in the terminal, but mirrors each response
into a browser page that renders Markdown **and LaTeX**. It only activates in
sessions you launch with the `claude-tex` command below — every plain `claude`
session is untouched.

## How the scoping works

The hook lives in `settings.json` here, and is loaded **only** when you pass
`--settings` on the command line. That flag is per-invocation, and Claude Code
*concatenates* hook arrays across settings sources rather than replacing them —
so this adds a `Stop` hook for that one session and changes nothing globally.
Nothing goes in `~/.claude/settings.json`.

## Install

1. Copy this whole folder to `~/.claude/latex-render/` so you end up with:

   ```
   ~/.claude/latex-render/
   ├── settings.json
   ├── render_turn.py
   └── web/
       └── index.html
   ```

2. Add this function to your `~/.zshrc` or `~/.bashrc`, then restart the shell:

   ```bash
   claude-tex() {
     local dir="$HOME/.claude/latex-render"
     # start the viewer server once, if it isn't already up
     if ! curl -fs -o /dev/null "http://localhost:7777/index.html"; then
       ( cd "$dir/web" && python3 -m http.server 7777 >/dev/null 2>&1 & )
       sleep 0.4
       command -v open      >/dev/null && open      "http://localhost:7777/" \
         || command -v xdg-open >/dev/null && xdg-open "http://localhost:7777/"
     fi
     claude --settings "$dir/settings.json" "$@"
   }
   ```

## Use

```bash
cd ~/some/project
claude-tex                 # rendering on; viewer opens at localhost:7777
# ...ask as usual. Each finished answer appears rendered in the browser.

claude                     # rendering off; completely normal session
```

Any extra arguments pass straight through, e.g. `claude-tex --model opus`.

## Toggles

Top of `render_turn.py`:

- `FULL_TRANSCRIPT = True` — show the whole conversation (scrolls). Set `False`
  to show only the most recent answer.
- `SHOW_USER = True` — include your own prompts. Set `False` for Claude's
  replies only.

## Caveats

- **Render-on-turn-end.** The `Stop` hook fires when an answer finishes, so the
  browser updates once per completed turn, not token-by-token.
- **Dollar delimiters.** The viewer treats `$...$` as inline math and `$$...$$`
  as display math. Prose with literal currency (`$5`) can occasionally be read
  as math. To change this, edit `delimiters: "dollars"` in `index.html`
  (`"brackets"` uses `\(...\)` / `\[...\]` instead).
- **Port 7777** is hard-coded in both the launcher and is just the directory the
  server serves; change it in the `claude-tex` function if it clashes.
- The transcript schema isn't a published contract. `render_turn.py` parses
  defensively (text blocks only, tool/thinking blocks dropped); if a future
  Claude Code version reshapes it, the parsing in that one file is where to look.
