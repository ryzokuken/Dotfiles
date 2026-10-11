# JS/TS stack

Default stack for every web, tooling, and script project. Config below is the enforcement; copy it
when scaffolding, and let the config, not prose, hold the line afterwards.

## Toolchain

| Job | Tool |
|-----|------|
| Runtime | Node, latest release (pinned below) |
| Package manager | pnpm only (`packageManager` field set; delete any `package-lock.json`) |
| Bundler / dev server | vite |
| Test | vitest, colocated `*.test.ts(x)`; a `test/` directory for code that is not a module (templates, static sites) |
| Lint | oxlint |
| Format | oxfmt (`oxfmt` writes, `oxfmt --check` gates) |
| Types | `tsc --noEmit` |
| Duplication | jscpd |
| Dead code | knip |
| Git hooks | simple-git-hooks, lint-staged |
| Desktop apps | Tauri (Rust core: also read `rust.md`) |

A tool earns its place when `pnpm install` sets it up and its config sits in the repo. One that
cannot be a clean devDependency (actionlint, zizmor) is installed per machine and named in the
project's docs.

## The gate

One `validate` script is the single gate: typecheck, lint, format check, unit tests, jscpd, knip.
It holds only checks that are fast, offline, and deterministic. A networked or slow check (link
crawl, browser smoke test) is its own CI job.

```json
"scripts": {
  "validate": "pnpm typecheck && pnpm lint && pnpm fmt:check && pnpm test && pnpm dupes && pnpm knip",
  "prepare": "simple-git-hooks"
},
"simple-git-hooks": {
  "pre-commit": "[ \"$(git branch --show-current)\" != main ] || { echo 'Commit on a branch; main takes PRs only.' >&2; exit 1; }; pnpm exec lint-staged",
  "pre-push": "if grep -q ' refs/heads/main '; then echo 'Push a branch; main takes PRs only.' >&2; exit 1; fi; pnpm validate"
}
```

- A commit checks the staged files through lint-staged (format, lint, `vitest related`); a push
  and CI run `validate`.
- The two `main` checks are the branch protection, since private repos have none on GitHub. A
  project that commits to `main` leaves both out.
- `pnpm install` wires the hooks through `prepare`; run `pnpm run prepare` when `.git/hooks`
  holds only `.sample` files.
- jscpd: `minTokens: 35` and a `threshold` set to the repo's measured duplication, rounded up, and
  lowered as copies are removed. It is a ceiling against new copies; the third copy is still found
  by reading.
- A repo with a handful of scripts leaves jscpd and knip out.

## Node version: latest, pinned by pnpm

```json
"devEngines": { "runtime": { "name": "node", "version": ">=26", "onFail": "download" } }
```

- Set the floor to the current major. `pnpm install` resolves the latest matching release, records
  the exact version and checksum in `pnpm-lock.yaml`, and a bare `node` inside the project follows
  that pin.
- `pnpm install` keeps the locked version; `pnpm update` moves it to the latest match.
- Odd-numbered "Current" majors lose support in about six months, so raise the floor on every new
  major. CI reads the same field; no `.node-version`, nvm, or mise.

## Supply chain

pnpm's defaults are the guard, so no repo restates them: a release must be a day old before it
resolves, and a dependency's build script fails the install until `allowBuilds` in
`pnpm-workspace.yaml` names it. Leave `ignoreScripts` unset; it also skips the project's own
`prepare`, which installs the git hooks. Global config holds only the exact-version save prefix.
Before installing, run `pnpm audit --audit-level=moderate`.

## Lint limits (oxlint)

```jsonc
{
  "plugins": ["typescript", "import", "unicorn"],
  "rules": {
    "complexity": ["error", { "max": 8 }],
    "max-lines-per-function": ["error", { "max": 100 }],
    "max-params": ["error", { "max": 5 }]
  }
}
```

Run with `oxlint --deny-warnings` so warnings fail the gate.

## TypeScript (apps and libraries)

```jsonc
"strict": true,
"noUncheckedIndexedAccess": true,
"exactOptionalPropertyTypes": true,
"noImplicitOverride": true,
"noPropertyAccessFromIndexSignature": true,
"noImplicitReturns": true,
"noFallthroughCasesInSwitch": true,
"verbatimModuleSyntax": true,
"isolatedModules": true,
"erasableSyntaxOnly": true,
"allowImportingTsExtensions": true
```

ESM only (`"type": "module"`). Node runs `.ts` directly by stripping types, so scripts need no build
step: `erasableSyntaxOnly` keeps the syntax strippable, and relative imports carry the `.ts`
extension. Unused code is oxlint's and knip's to report, so `noUnusedLocals` and
`noUnusedParameters` stay off.

## Plain JS (small scripts, tools, static sites)

ESM with JSDoc types, checked by `tsc --noEmit` with `allowJs` and `checkJs`. Skip the build step
when it would be the heaviest part of the project.

## Trying new tools

Evaluate in a scratch project. Adopting one means editing this file.
