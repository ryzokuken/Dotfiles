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

**OS-conditional pattern** (used in `settings.json.tmpl`):
```
{{- if eq .chezmoi.os "windows" -}}
  ... windows config ...
{{- else -}}
  ... linux config ...
{{- end }}
```

## Shell Environment

`dot_zshrc` uses Oh My Zsh with starship prompt. Key aliases set for interactive shells:

| Alias | Resolves to | Notes |
|-------|-------------|-------|
| `ls` | `eza --icons --group-directories-first` | |
| `ll` | `eza -l --icons --git --group-directories-first` | |
| `lt` | `eza --tree --level=2 --icons` | |
| `cat` | `bat --paging=never` | adds syntax color to output |
| `grep` | `rg` | different flag syntax than GNU grep |
| `find` | `fd` | completely different syntax than GNU find |
| `top` | `btm` | bottom TUI process viewer |
| `du` | `dust` | visual disk usage |
| `help` | `tldr` | overrides zsh builtin |
| `z` | zoxide | frecency-aware cd (eval'd, not a simple alias) |
| `c` | `chezmoi` | quick shorthand |
| `vi`, `vim` | `nvim` | |

**Critical:** These aliases are interactive-only (loaded from `.zshrc`). Shell scripts, cron jobs,
and non-interactive invocations see the real binaries. Always write scripts using the canonical names
(`rg`, `fd`, `bat`, `eza`) — they're installed system-wide and work in all contexts.

Installed via `yay -S eza bat ripgrep fd zoxide bottom dust tealdeer`.

## Claude Code Config (`dot_claude/`)

Deployed to `~/.claude/`. Contains:

- `CLAUDE.md` — global instructions (symlinked from repo)
- `settings.json.tmpl` — OS-conditional Claude Code settings; Windows branch omits Linux-only keys
  (`hooks`, `statusLine`, `enabledPlugins`)
- `executable_statusline.sh` — shell script for Claude Code status bar (shows cost + EUR)
- `executable_fetch-eur-rate.sh` — fetches EUR/USD rate for statusline
- `commands/` — custom slash commands

`settings.local.json` (in `.claude/`, not in chezmoi) holds machine-local overrides:
`enableAllProjectMcpServers` and `enabledMcpjsonServers`.

## .chezmoiignore

`README.md` is excluded from deployment. Linux-only paths (statusline scripts, systemd units) are
excluded on Windows.

## Repo Structure

```
dot_claude/          → ~/.claude/
dot_config/          → ~/.config/    (alacritty, i3, nvim, kitty, starship, systemd, …)
private_dot_gnupg/   → ~/.gnupg/     (0600)
dot_zshrc            → ~/.zshrc
dot_gitconfig        → ~/.gitconfig
dot_tmux.conf        → ~/.tmux.conf
```
