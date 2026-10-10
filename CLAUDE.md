# Dotfiles (chezmoi) — CachyOS/Arch Linux

Dotfiles managed by [chezmoi](https://www.chezmoi.io/). Repo lives at `~/.local/share/chezmoi`.

## Chezmoi Workflow

```sh
chezmoi apply          # deploy repo → home dir  (alias: c apply)
chezmoi edit ~/.zshrc  # open managed file for editing
chezmoi re-add ~/.zshrc # pull live changes back into repo
chezmoi diff           # preview what apply would change
chezmoi update         # git pull + apply
```

Editing files directly in the repo is fine. Always run `chezmoi apply` (or `c apply`) after changes
to deploy them, then commit.

## File Naming Conventions

| Prefix | Effect on deployment |
|--------|----------------------|
| `dot_` | replaces with `.` (e.g. `dot_zshrc` → `~/.zshrc`) |
| `private_` | 0600 permissions |
| `executable_` | sets executable bit |
| `*.tmpl` | processed as Go template before writing |

Prefixes stack: `private_dot_gnupg/` → `~/.gnupg/` with restricted perms.

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
  `pnpx skills@latest add -g -a claude-code` produces. `promote-prefs` lives here.
- `dot_claude/commands/` — custom slash commands.
- `dot_claude/executable_statusline.sh` — status bar: context bar, 5h/7d rate-limit bars with
  reset countdowns, and session cost in EUR; `executable_fetch-eur-rate.sh` feeds it the EUR/USD
  rate.
- `.chezmoitemplates/pnpm-config.yaml` — global pnpm settings, deployed to `~/.config/pnpm/`
  (Linux) and `AppData/Local/pnpm/config/` (Windows).

`settings.json` is intentionally **not** tracked here — it churns too often (plugin toggles, model
overrides) to be worth reconciling against a template. It's machine-local, managed by hand, and it
holds the hooks that block `rm -rf` and pushes to `main`. `settings.local.json` similarly holds
machine-local overrides: `enableAllProjectMcpServers` and `enabledMcpjsonServers`.

## .chezmoiignore

`README.md` and `CLAUDE.md` (this file) are excluded from deployment — they document the repo
itself and aren't meant to land in `$HOME`. Per-OS files are excluded too. Patterns match **target**
paths (`.claude/statusline.sh`), not source names (`dot_claude/executable_statusline.sh`); a
source-style pattern matches nothing.

## Repo Structure

```
dot_claude/          → ~/.claude/
dot_agents/          → ~/.agents/
dot_config/          → ~/.config/    (alacritty, i3, nvim, kitty, starship, systemd, pnpm, …)
AppData/             → ~/AppData/    (Windows only)
private_dot_gnupg/   → ~/.gnupg/     (0600)
dot_zshrc            → ~/.zshrc
dot_gitconfig        → ~/.gitconfig
dot_tmux.conf        → ~/.tmux.conf
```
