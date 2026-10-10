# Windows (flying-dutchman)

The daily-driver machine. Facts from the repos so far; extend this file when a session on this
machine learns a durable one.

## Shell
- Use plain `bash`. `git`, `gh`, `node`, and `pnpm` are on its PATH; run them directly.
- Reach for PowerShell only when a task needs it, and call the command itself, with no
  `pwsh -Command` wrapper.
- winget portable installs (`actionlint`, `zizmor`) are missing from a session's frozen PATH; invoke
  the binary by path.
- Deletion: no `trash` or `gio` here; list files before removing and never `rm -rf`.

## Files and repos
- Write LF line endings. `.gitattributes` (`* text=auto eol=lf`) carries this in each repo; the
  deployed gitconfig sets `core.autocrlf = input` only to override Git for Windows' system default
  of `true` in repos that lack one.
- Keep task scripts cross-platform (no Bash-only commands in `package.json` scripts) and build paths
  with `node:path`.
- The statusline scripts, systemd units, `.zshrc`, and `linux.md` are Linux-only and not deployed
  here.

## Toolchain
- Rust stable (MSVC), Visual Studio Build Tools with "Desktop development with C++", pnpm, Node.
  No Deno.
- A winget Build Tools install has landed without the C++ workload; check that `VC\Tools\MSVC`
  exists instead of trusting "installed".
