# Audit: one project against global

Make this project's instructions lean, consistent with global, and free of lines that mislead.

## Steps

1. **Inventory.** Read the project's `CLAUDE.md`, `AGENTS.md`, `CLAUDE.local.md`, `docs/agents/`,
   `.claude/settings.json`, and its memory directory (`~/.claude/projects/<mangled-path>/memory/`).
   Read `~/.claude/CLAUDE.md` and the global docs the project's stack points to.
2. **Classify every instruction line** into one finding type, or **keep**:
   - **Contradiction**: global vs project, or two project files disagreeing.
   - **Duplicate**: the same meaning stated twice (including a project line that restates global).
   - **Cache**: a copy of what the environment states (scripts, versions, config values); keep it
     only when the lookup is expensive.
   - **No-op**: an instruction the agent follows by default.
   - **Stale**: names a path, command, issue, or branch that no longer exists. Check each with
     `fd`, `rg`, or `gh`.
   - **Promote**: a rule other projects share (hand it to **sweep**).
   - **Sprawl**: reference that only some branches need; move it behind a pointer.
   - **Negation**: a prohibition without the positive behaviour; rewrite it positively.
3. **Check the overrides.** For each place the project overrides global, confirm the reason is
   written next to it. An override without a reason is a finding.
4. **Report** findings ordered by harm (contradictions first), each with `file:line`, the issue,
   and the proposed edit.

Done when every instruction line in every inspected file has a classification and every
non-keep line has a proposed edit.

## Apply

After approval, make the edits on a branch in the project. Memory files change in place; delete a
memory the audit proves wrong.
