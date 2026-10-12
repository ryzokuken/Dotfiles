# Dotfiles (chezmoi)

Dotfiles managed by [chezmoi](https://www.chezmoi.io/). Repo lives at `~/.local/share/chezmoi`.

## Chezmoi Workflow

Editing files directly in the repo is fine. Always run `chezmoi apply` (or `c apply`) after changes
to deploy them, then commit. This repo is solo and commits to `master`.

## Templates

Files with `.tmpl` suffix are Go text/template processed by chezmoi. Missing `{{- end }}` tags will
silently produce broken output — always verify template structure.

**OS-conditional pattern** (used in `.chezmoiignore`):
```
{{ if eq .chezmoi.os "windows" }}
  ... windows-only config ...
{{ else }}
  ... linux config ...
{{ end }}
```

Two machines: `burla-negra` (Linux, CachyOS/Arch) and `flying-dutchman` (Windows).

## Shell Environment

`dot_zshrc` is the source of truth for aliases (eza, bat, rg, fd, and others) and the Oh My Zsh and
starship setup. Interactive aliases also reach Claude Code's Bash tool;
`dot_claude/docs/linux.md` holds the agent-facing consequences.

Installed via `yay -S eza bat ripgrep fd zoxide bottom dust tealdeer`.

## Claude Code Config

Global instructions deploy to `~/.claude/`. Edit them here, then `chezmoi apply`.

- `dot_claude/CLAUDE.md` — the lean core, loaded in every session. Keep it under about 80 lines.
- `dot_claude/docs/` — stack and platform docs the core points to (`js-ts`, `python`, `rust`,
  `github-actions`, `linux`, `windows`). Each platform doc deploys only on its OS.
- `dot_agents/skills/` — skills in the open Agent Skills format, deployed to `~/.agents/skills/`;
  `dot_claude/skills/symlink_<name>` links each into `~/.claude/skills/`, the same layout
  `pnpx skills@latest add -g -a claude-code` produces. `promote-prefs` and `fix-issue` live
  here.
- `dot_claude/hooks/guard-bash.mjs` — PreToolUse guard that blocks recursive forced `rm` and
  pushes to `main`/`master`. Its tests are in `tests/`; run `node --test tests/` after editing it.
- `dot_claude/executable_statusline.sh` — status bar: context bar, 5h/7d rate-limit bars with
  reset countdowns, and session cost in EUR; `executable_fetch-eur-rate.sh` feeds it the EUR/USD
  rate.
- `.chezmoitemplates/pnpm-config.yaml` — global pnpm settings, deployed to `~/.config/pnpm/`
  (Linux) and `AppData/Local/pnpm/config/` (Windows).

`settings.json` is intentionally **not** tracked here — it churns too often (plugin toggles, model
overrides) to be worth reconciling against a template. It's machine-local, managed by hand, and its
Bash `PreToolUse` hook runs `node "$HOME/.claude/hooks/guard-bash.mjs"` with `"onFailure": "block"`
(needs Claude Code 2.1.295), so a missing script blocks Bash until `chezmoi apply` restores it.
`settings.local.json` similarly holds machine-local overrides such as
`enableAllProjectMcpServers`.

## .chezmoiignore

Meta files (`README.md`, `CLAUDE.md` (this file), `AGENTS.md`, `GLOSSARY.md`, `docs/`,
`.scratch/`) are excluded from deployment — they document the repo itself and aren't meant to land
in `$HOME`. Only actual config deploys; add any new meta file or directory to this list. Per-OS
files are excluded too. Patterns match **target**
paths (`.claude/statusline.sh`), not source names (`dot_claude/executable_statusline.sh`); a
source-style pattern matches nothing.

## Agent skills

### Issue tracker

Issues live as GitHub issues on ryzokuken/Dotfiles; skills use the `gh` CLI. See
`docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`,
`wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout: root `GLOSSARY.md` + `docs/adr/`. See `docs/agents/domain.md`.
