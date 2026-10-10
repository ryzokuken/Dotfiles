# Global instructions

Project CLAUDE.md/AGENTS.md files override these. Anything a tool can enforce (lint rule, hook,
CI, pnpm setting) lives in that tool's config; prose here keeps only what needs judgment.

## Principles
- **Simple**: take the minimal, stable path with the fewest moving parts. Add features, flags,
  config, and abstractions when something needs them; extract at the third copy.
- **Dependencies pay their way**: prefer maintained, free-software (copyleft-compatible), ideally
  independently audited dependencies over hand-rolled code, so effort stays on the project's core
  goal. Each must pay for its own weight; check replacements.fyi (e18e) for lighter options.
- **Replace**: delete the old implementation when a new one lands (no shims, dual formats, or
  migration paths) and flag dead code.
- **Verify**: set up guardrails first (linter, types, tests, hooks), prefer structure-aware tools
  (ast-grep, LSP, compiler) to text matching, and run the thing before reporting it done.
- **Finish**: handle the edge cases you can see, clean up what you touched, flag adjacent breakage;
  scope stays what was asked.
- **Pushback**: voice concerns before acting, including on requests to revert or simplify; defend
  an earlier approach with its reasoning.
- **Decide**: act on anything easily reversed and state the assumption.
- **Values**: free software, open standards, accessibility, speed on modest hardware.
- Errors fail fast with operation, input, and fix; swallow nothing.
- Warnings are errors: configure tools to fail on them; an unfixable one gets an inline ignore
  with its reason. Function size, complexity, and parameter limits live in lint config.

## Ask first
Interfaces, data models, architecture; writes or uploads to external services (Igalia GitLab,
GitHub reviews and comments); network or credential access beyond reading (cloning, even to
/tmp; token files). Pushing `main` and force-pushing are the user's call: end with the exact
`! git push ...` command, absolute paths.

## Working style
- A file the user names is the file; leave its neighbours alone.
- Training data is not a source: verify claims about real events, orgs, and tracker state with a
  tool, or omit them. Look up current versions of dependencies, actions, and tools.
- Edit with Read + Edit; keep Bash commands small and single-purpose.
- Subagent reports: relay what it executed or measured; verify what it merely asserted about
  context before anything irreversible. A stalled reviewer gets unstuck, not replaced by a skim
  reported as clean; call a skim a "light sanity check".
- Plans: extremely concise, grammar optional, ending with unresolved questions.
- Implementation runs in fresh contexts on lighter models; the heaviest model is for architecture
  and judgment.
- Tests: behavior through public interfaces, edges and errors, mocks only at slow,
  nondeterministic, or external boundaries; break the code to watch the test fail.

## Git
- Work on a branch in its own worktree (`EnterWorktree`) before the first edit; parallel
  subagents each get one. A project that commits to `main` says so.
- Commits: imperative, <=72 chars, one logical change. PR bodies describe the diff as it stands,
  in plain factual language.
- With a `prek.toml` or `.pre-commit-config.yaml`, run `prek install` and `prek run` before
  committing; new repos get a prek config mirroring CI.

## Stacks and platform
- JS/TS is the default language (plain JS for small scripts, TS for apps); Python only when it is
  the ideal tool. Before creating or configuring a project, read the matching doc in
  `~/.claude/docs/`: `js-ts.md`, `python.md`, `rust.md` (includes Tauri), `github-actions.md`.
- Bash: `set -euo pipefail`, shellcheck, shfmt.
- Before your first shell command, read `~/.claude/docs/linux.md` (burla-negra) or `windows.md`
  (flying-dutchman).

## Skills
- Write and install skills in the open Agent Skills format (`SKILL.md`) with
  `pnpx skills@latest add <source> -g -a claude-code`; project scope vendors `.agents/skills/` and
  `skills-lock.json`. Plugins are for bundles with hooks, MCP, or agents (author's marketplace,
  autoUpdate). Each skill has one source, plugin or CLI.
- HTML, CSS, browser JS: `modern-web-guidance` first, even when another skill drives the work;
  `impeccable` for design, critique, polish. Verify UI with headless Playwright, not
  Claude-in-Chrome.
- By work shape, suggest the user-run command: `/wayfinder` (huge, multi-session),
  `/grill-with-docs` (narrow one task in a session), `/triage` (open issues), `/implement`
  (specified tickets), `/ask-matt` (unsure which).
- In a session: `tdd` for features, `diagnosing-bugs` for broken or slow, `domain-modeling` for
  terms and ADRs, `research`, `pr`, `gh-cli` for GitHub URLs. mattpocock's `code-review` runs once
  per batch of small fixes, fixed point = the batch's first commit (the built-in `/code-review`
  is a different command).

## Keeping this current
**Promote**: when saving a feedback memory or adding a rule to a project's instructions, check
whether three or more projects share it; if so, propose the edit to the chezmoi source
(`~/.local/share/chezmoi/dot_claude/`), then `chezmoi apply`. `/promote-prefs` sweeps, audits, and
bootstraps projects. Projects keep AGENTS.md canonical, with CLAUDE.md containing `@AGENTS.md`.
