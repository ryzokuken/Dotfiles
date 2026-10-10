---
name: promote-prefs
description: Keep the global Claude setup current and project instruction files lean and consistent. Sweep projects for rules worth promoting to global, audit one project against global, or bootstrap a new project.
disable-model-invocation: true
---

# Promote prefs

Instruction files drift: a rule learned in one project belongs everywhere, a project rule goes
stale, two files disagree. This skill finds those cases and proposes the fix.

## Pick a mode

Use the argument if given (`sweep`, `audit`, `init`). Without one:

- Outside a git project, or inside `~/.local/share/chezmoi`: **sweep**.
- Inside a project with a CLAUDE.md or AGENTS.md: **audit**.
- Inside a project with neither: **init**.

Read the mode's file, and only that one: [sweep.md](sweep.md), [audit.md](audit.md),
[init.md](init.md).

## Rules for every mode

- **Propose, then ask.** Show each change as a diff with its evidence (file path and line); write
  nothing until the user approves.
- **Global edits** go to the chezmoi source (`~/.local/share/chezmoi/dot_claude/`), then
  `chezmoi apply`, on a branch. **Project edits** go on a branch in that project.
- **One source of truth per meaning.** Environment files (`package.json` scripts, lint config,
  `--help`) own what they state; instruction files hold the unwritten convention, the reason, and
  the gotcha.
- Apply the `writing-for-agents` skill's levers (pointers, leading words, positive phrasing, no-op
  hunt) to every line you propose.
