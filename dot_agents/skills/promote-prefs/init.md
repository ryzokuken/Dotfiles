# Init: first-time project setup

Bootstrap a project so that it starts consistent with global. Unlike an audit, init creates the
files and has no memories to mine.

## Steps

1. **Detect.** Identify the stack (`package.json`, `Cargo.toml`, `pyproject.toml`), the git
   default branch, existing hooks, and existing CLAUDE.md or AGENTS.md. If instruction files
   already exist, switch to **audit**.
2. **Ask first.** Any interface, data-model, or architecture choice goes to the user; propose a
   default for each and wait.
3. **Instruction files.** Write `AGENTS.md` (the canonical file) with only what the agent cannot
   find by looking: the project's purpose in a paragraph, unwritten conventions with reasons,
   gotchas, and pointers to deeper docs. Write `CLAUDE.md` as one line, `@AGENTS.md`. Every line of
   AGENTS.md must pass the test: would the agent get this wrong without it?
4. **Wire the stack** from the global doc for it. For JS/TS: `packageManager`, `devEngines.runtime`,
   a `validate` script (typecheck, lint, test), the oxlint limits and strict tsconfig, and a
   `prek.toml` with `no-commit-to-branch` plus `validate`. Add a CI workflow that calls the same
   `validate` script.
5. **Skills.** Ask which skills the project needs. Vendor them at project scope with
   `pnpx skills@latest add <source> -a claude-code`, which writes `.agents/skills/` and
   `skills-lock.json`. Turn off a plugin copy of the same skill in `.claude/settings.json`.
   For mattpocock's skills, run `setup-matt-pocock-skills` to choose the issue tracker, triage
   labels, and domain-doc layout.
6. **Verify.** On a clean checkout, `pnpm install && pnpm validate` passes and `prek run` is
   green.

Done when the verify step passes and AGENTS.md is under about 40 lines.
