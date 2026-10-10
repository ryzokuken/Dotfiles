# Python stack

Python is for jobs where it is the ideal tool (data work, existing Python ecosystems). Everything
else defaults to JS/TS.

| Job | Tool |
|-----|------|
| Deps and venv | uv, Python 3.13, `uv venv` |
| Lint and format | `ruff check`, `ruff format` |
| Types | `ty check` (strictness under `[tool.ty.rules]` in `pyproject.toml`) |
| Test | `pytest -q`, `tests/` mirroring the package |
| Build backend | `uv_build` for pure Python, `hatchling` for extensions |

## Limits (ruff)

```toml
[tool.ruff.lint]
select = ["E", "F", "I", "C90", "PLR0913", "PLR0915"]

[tool.ruff.lint.mccabe]
max-complexity = 8

[tool.ruff.lint.pylint]
max-args = 5
max-statements = 50
```

Ruff has no per-function line limit, so a 50-statement cap stands in for the 100-line rule.

## Supply chain

Pin exact versions (`==`), install with `uv pip install --require-hashes`, and run `pip-audit`
before deploying. Google-style docstrings on non-trivial public APIs.
