# Windows (flying-dutchman)

Facts from the repos so far; extend this file when a session on this machine learns a durable one
(shell, package manager, path quirks).

- Write LF line endings; never rely on `core.autocrlf`.
- Keep task scripts cross-platform (no Bash-only commands in `package.json` or `deno.json` tasks)
  and build paths with `node:path`.
- The statusline scripts and systemd units are Linux-only and are not deployed here.
