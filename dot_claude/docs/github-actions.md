# GitHub Actions

- Pin every action to a full commit SHA with the version in a comment:
  `actions/checkout@<full-sha>  # vX.Y.Z`, with `persist-credentials: false`.
- Look up the current stable release of each action when adding or bumping it.
- Lint workflows with `actionlint` and audit them with `zizmor`; both run in prek and in CI.
- Dependabot: 7-day cooldown and grouped updates. Use the `npm` ecosystem for pnpm projects and
  `uv` (not `pip`) for Python projects so `uv.lock` is updated.
