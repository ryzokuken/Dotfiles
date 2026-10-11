# Rust stack

Used for Tauri backends and the occasional native tool. Toolchain: latest stable via `rustup`,
pinned per project with `rust-toolchain.toml`.

| Job | Command |
|-----|---------|
| Lint | `cargo clippy --all-targets --all-features -- -D warnings` |
| Format | `cargo fmt` |
| Test | `cargo test` |
| Supply chain | `cargo deny check` (install on the first Rust project) |

## Lints (`Cargo.toml`)

```toml
[lints.clippy]
pedantic = { level = "warn", priority = -1 }
unwrap_used = "deny"
expect_used = "warn"
panic = "deny"
panic_in_result_fn = "deny"
unimplemented = "deny"
allow_attributes = "deny"
dbg_macro = "deny"
todo = "deny"
print_stdout = "deny"
print_stderr = "deny"
await_holding_lock = "deny"
large_futures = "deny"
exit = "deny"
mem_forget = "deny"
cognitive_complexity = "deny"
too_many_arguments = "deny"
module_name_repetitions = "allow"
similar_names = "allow"
```

Set `cognitive-complexity-threshold = 8` and `too-many-arguments-threshold = 5` in `clippy.toml`.

## Style clippy cannot check

- `for` loops with mutable accumulators over iterator chains.
- Shadow variables through transformations (no `raw_x` / `parsed_x`).
- Destructure explicitly instead of `matches!`; keep wildcard arms out of matches.
- `let ... else` for early returns, keeping the happy path unindented.
- Newtypes over primitives (`UserId(u64)`); enums for state machines, not boolean flags.
- `thiserror` in libraries, `anyhow` in applications; `tracing` for logging.
- Profile before micro-optimizing.

## Tauri

- Pin the `tauri` and plugin crates with `=` and move them together with the matching `@tauri-apps`
  npm packages; commit `Cargo.lock`. A loose range once let `tauri-runtime` 2.12 in, which
  `tauri` 2.11.6 cannot run against (logseq-tools ADR 0009).
- Verify the page in the running window: on Windows, start the app with
  `WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS=--remote-debugging-port=9333` and drive it over the
  DevTools protocol.
