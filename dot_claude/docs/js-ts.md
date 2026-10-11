# JS/TS stack

Default stack for every web, tooling, and script project. Config below is the enforcement; copy it
when scaffolding, and let the config, not prose, hold the line afterwards.

## Toolchain

| Job | Tool |
|-----|------|
| Runtime | Node, latest release (pinned below) |
| Package manager | pnpm only (`packageManager` field set; delete any `package-lock.json`) |
| Bundler / dev server | vite |
| Test | vitest, colocated `*.test.ts` |
| Lint | oxlint |
| Format | oxfmt |
| Types | `tsc --noEmit` |
| Desktop apps | Tauri (Rust core: also read `rust.md`) |

One `validate` script (typecheck, lint, format check, test) is the single gate; CI and prek both
call it.

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

Global pnpm config (`minimumReleaseAge`, `ignoreScripts`, exact-version save prefix) is managed in
the chezmoi repo and applies to every project. Each repo also carries `minimumReleaseAge` and
`ignoreScripts` in its own `pnpm-workspace.yaml`, so the guard travels with the repo. Before
installing, run `pnpm audit --audit-level=moderate`.

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
"verbatimModuleSyntax": true,
"isolatedModules": true,
"erasableSyntaxOnly": true,
"allowImportingTsExtensions": true
```

ESM only (`"type": "module"`). Node runs `.ts` directly by stripping types, so scripts need no build
step: `erasableSyntaxOnly` keeps the syntax strippable, and relative imports carry the `.ts`
extension.

## Plain JS (small scripts, tools, static sites)

ESM with JSDoc types, checked by `tsc --noEmit` with `allowJs` and `checkJs`. Skip the build step
when it would be the heaviest part of the project.

## Trying new tools

Evaluate in a scratch project. Adopting one means editing this file.
