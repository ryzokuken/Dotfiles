# Linux (Arch/CachyOS, burla-negra)

The Bash tool starts from the user's zsh profile, so interactive aliases leak in: `cat` is `bat`,
`ls` is `eza`, and `grep` and `find` are shell functions. Plan for it:

- Read files with the Read tool; use `command cat` when raw bytes matter.
- Search with `rg` and `fd` by name; use `ast-grep` for structural search.
- Prefix paths that start with a dash with `./` (the memory directories do).
- Delete with `gio trash`, which is recoverable.
- Packages: `yay` / `pacman`.
