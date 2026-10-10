# Sweep: promote recurring rules to global

Find rules that hold across projects but are missing from the global setup, and global rules that
projects keep overriding.

## Steps

1. **Inventory.** List every project memory directory under `~/.claude/projects/*/memory/` and
   every `CLAUDE.md`, `AGENTS.md`, and `CLAUDE.local.md` under `~/code/`. Skip worktree copies of
   the same project. Done when each project appears in a table with the files you read.
2. **Extract rules.** From each file, take the feedback and preference rules (memory type
   `feedback` or `user`, plus imperative lines in instruction files). Group rules that mean the
   same thing under one name, whatever their wording.
3. **Count.** A rule is a **promotion candidate** when three or more projects hold it, or the user
   said it applies everywhere ("from now on", "always"). Single-project rules stay put.
4. **Check global.** Read `~/.claude/CLAUDE.md` and `~/.claude/docs/`. Drop candidates already
   covered; flag global rules that two or more projects override or contradict as **removal or
   softening candidates**.
5. **Propose.** Group by target file (core, or a stack/platform doc). For each: the rule, the
   projects holding it (paths), and the exact diff. Core additions must pass the no-op test: would
   the agent get this wrong without the line? Prefer the stack docs over the core for anything
   stack-specific.

Done when every extracted rule is classified (promote, covered, project-specific, or override
signal) and every candidate has a diff.

## Apply

After approval, edit the chezmoi source, run `chezmoi diff`, then `chezmoi apply`. Recount the
core's lines afterwards; the core stays under about 80.
