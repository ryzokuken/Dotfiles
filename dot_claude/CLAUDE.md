# Global instructions

Project CLAUDE.md/AGENTS.md files override these. Anything a tool can enforce (lint rule, hook,
CI, pnpm setting) lives in that tool's config; prose here keeps only what needs judgment.

## Principles
- **Simple**: take the minimal, stable path with the fewest moving parts. Add features, flags,
  config, and abstractions when something needs them; extract at the third copy.
- **Dependencies pay their way**: prefer maintained, free-software (copyleft-compatible), ideally
  audited dependencies over hand-rolled code; check replacements.fyi (e18e) for lighter options.
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
- Training data is not a source: verify real events, orgs, tracker state, and versions with a tool,
  or omit them. Look up in order: installed source, official docs, Context7, Exa, WebSearch.
- Edit with Read + Edit; keep Bash commands small and single-purpose.
- Subagent reports: relay what it executed or measured; verify what it merely asserted about
  context before anything irreversible. A stalled reviewer gets unstuck, not replaced by a skim
  reported as clean; call a skim a "light sanity check".
- Plans: extremely concise, grammar optional, ending with unresolved questions.
- Implement in fresh contexts on lighter models; the heaviest model is for architecture, judgment.
- Tests: behavior through public interfaces, edges and errors, mocks only at slow,
  nondeterministic, or external boundaries; break the code to watch the test fail.

## Git
- Work on a branch (`<slug>-<issue>`, or `<slug>`) in its own worktree (`EnterWorktree`) before
  the first edit; parallel subagents each get one. A solo project that commits to `main` says so
  in one line.
- Subjects: plain imperative, <=72 chars, no type prefix; a body when the reason is not obvious.
  Commit each finished piece: PRs land by squash, so the PR title is the subject on `main`.
- PR bodies describe the diff as it stands, in plain factual language, and carry `Fixes #N`.
- A `prek.toml` or `.pre-commit-config.yaml` needs `prek install`, and `prek run` before commits.

## Stacks and platform
- JS/TS is the default language (plain JS for small scripts, TS for apps); Python only when it is
  the ideal tool. Before creating or configuring a project, read the matching doc in
  `~/.claude/docs/`: `js-ts.md`, `python.md`, `rust.md` (includes Tauri), `github-actions.md`.
- Bash: `set -euo pipefail`, shellcheck, shfmt.
- Before your first shell command, read `~/.claude/docs/linux.md` (burla-negra) or `windows.md`
  (flying-dutchman).

## Skills
- Write skills in the open Agent Skills format (`SKILL.md`); install with `pnpx skills@latest
  add <source> -g -a claude-code`. Plugins (author's marketplace, autoUpdate): hooks, MCP, agents.
- Each skill loads from one source: global plugins in a solo project, vendored copies in a project
  with other contributors (`promote-prefs` init has the steps).
- HTML, CSS, browser JS: `modern-web-guidance` first, even when another skill drives the work;
  `impeccable` for design, critique, polish. Verify UI with `agent-browser`, whose skill is
  vendored in browser projects only; no Playwright MCP, no Claude-in-Chrome.
- By work shape, suggest the user-run command: `/wayfinder` (huge, multi-session),
  `/grill-with-docs` (narrow one task in a session), `/triage` (open issues), `/implement`
  (specified tickets), `/ask-matt` (unsure which).
- mattpocock's `code-review` runs once per batch of small fixes, fixed point = the batch's first
  commit (the built-in `/code-review` is a different command).

## Keeping this current
**Promote**: when saving a feedback memory or adding a rule to a project's instructions, check
whether three or more projects share it; if so, propose the edit to the chezmoi source
(`~/.local/share/chezmoi/dot_claude/`), then `chezmoi apply`. `/promote-prefs` sweeps, audits, and
bootstraps projects. A project with other contributors keeps AGENTS.md canonical, with CLAUDE.md
containing `@AGENTS.md`; a solo project keeps either file.
