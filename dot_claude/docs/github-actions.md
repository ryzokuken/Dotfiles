# GitHub Actions

- Pin every action to a full commit SHA with the version in a comment:
  `actions/checkout@<full-sha>  # vX.Y.Z`, with `persist-credentials: false`.
- Look up the current stable release of each action when adding or bumping it.
- Set `permissions: {}` at the top of each workflow and grant each job only what it needs.
- CI calls the project's gate (`pnpm validate`) as one step. A deploy job `needs` the gate job.
- Lint workflows with `actionlint` and audit them with `zizmor`; both run in the pre-push hook and
  in CI.
- Dependabot: 7-day cooldown and grouped updates, with the `github-actions` ecosystem alongside
  the package one. Use `npm` for pnpm projects and `uv` (not `pip`) for Python projects so
  `uv.lock` is updated.
- Rerun one failed job with `gh run rerun <run-id> --job <job-id>`, not the whole run.
