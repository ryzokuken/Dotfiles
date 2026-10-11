# Init: first-time project setup

Bootstrap a project so that it starts consistent with global. Unlike an audit, init creates the
files and has no memories to mine.

## Steps

1. **Detect.** Identify the stack (`package.json`, `Cargo.toml`, `pyproject.toml`), the git
   default branch, existing hooks, and existing CLAUDE.md or AGENTS.md. If instruction files
   already exist, switch to **audit**.
2. **Ask first.** Any interface, data-model, or architecture choice goes to the user; propose a
   default for each and wait.
3. **Instruction files.** Ask whether anyone else contributes. With other contributors, write
   `AGENTS.md` as the canonical file and `CLAUDE.md` as one line, `@AGENTS.md`; a solo project
   gets `CLAUDE.md` alone. Write only what the agent cannot find by looking: the project's purpose
   in a paragraph, unwritten conventions with reasons, gotchas, and pointers to deeper docs. Every
   line must pass the test: would the agent get this wrong without it?
4. **Wire the stack** from the global doc for it. For JS/TS, follow `js-ts.md`: `packageManager`,
   `devEngines.runtime`, the `validate` script, the hooks, the oxlint limits and the strict
   tsconfig. Add a CI workflow that calls the same `validate` script. A project that commits to
   `main` omits the two `main` checks; a project that declares no CI omits the workflow, and the
   pre-push hook is its only gate. A project without a `package.json` gets a `prek.toml` with
   `no-commit-to-branch` plus its gate.
5. **Skills.** A solo project uses the global plugins and skills as they are. With other
   contributors, ask which skills the project needs and vendor them at project scope with
   `pnpx skills@latest add <source> -a claude-code`, which writes `.agents/skills/` and
   `skills-lock.json`; turn off the matching global plugin by its exact key in
   `.claude/settings.json`. For mattpocock's skills, run `setup-matt-pocock-skills` to choose the
   issue tracker, triage labels, and domain-doc layout.
6. **Verify.** On a clean checkout, `pnpm install && pnpm validate` passes, `.git/hooks` holds
   the hooks, and a commit on `main` is refused where the project uses PRs.

Done when the verify step passes and the instruction file is under about 40 lines.
