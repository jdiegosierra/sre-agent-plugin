---
description: Detect the project test framework and run the test suite
---

You must detect the project's test framework and run the test suite. This is a direct action — execute immediately.

## Detection

Check for test configuration in this order. Use the **first match**:

1. **Vitest** — `vitest.config.*`, or `"vitest"` in package.json devDependencies → `npx vitest run`
2. **Jest** — `jest.config.*`, or `"jest"` in package.json → `npx jest`
3. **Mocha** — `.mocharc.*`, or `"mocha"` in package.json → `npx mocha`
4. **Pytest** (Python) — `pytest.ini`, `pyproject.toml` with `[tool.pytest]`, `conftest.py` → `pytest`
5. **Go test** — `go.mod` exists → `go test ./...`
6. **RSpec** (Ruby) — `spec/` directory, `.rspec` → `bundle exec rspec`
7. **Cargo test** (Rust) — `Cargo.toml` → `cargo test`

If a `Makefile` exists with a `test` target, prefer using that instead.

## Execution

1. Run the detected test suite.
2. Show the test results summary: total, passed, failed, skipped.
3. If tests fail, list each failing test with its error message clearly.

## If no test framework is found

Tell the user: "No test configuration detected in this project. Consider adding one (Vitest, Jest, Pytest, etc.)."
