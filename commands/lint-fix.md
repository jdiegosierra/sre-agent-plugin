---
description: Detect the project linter and run autofix on the codebase
---

You must detect the project's linter and run it with autofix enabled. This is a direct action — execute immediately.

## Detection

Check for linter configuration in this order. Use the **first match**:

1. **ESLint** — `eslint.config.*`, `.eslintrc.*`, or `"eslint"` in package.json devDependencies → `npx eslint --fix .`
2. **Biome** — `biome.json`, `biome.jsonc` → `npx biome check --fix .`
3. **Prettier** (formatting) — `.prettierrc*`, `"prettier"` in package.json → `npx prettier --write .`
4. **Ruff** (Python) — `ruff.toml`, `pyproject.toml` with `[tool.ruff]` → `ruff check --fix .`
5. **Black** (Python) — `pyproject.toml` with `[tool.black]` → `black .`
6. **golangci-lint** (Go) — `.golangci.yml`, `.golangci.yaml` → `golangci-lint run --fix`
7. **Rubocop** (Ruby) — `.rubocop.yml` → `rubocop -a`

If a `Makefile` exists with a `lint` or `lint-fix` target, prefer using that instead.

## Execution

1. Run the detected linter with autofix.
2. Show a summary of what changed (files modified, issues fixed).
3. If there are remaining issues that autofix cannot resolve, list them clearly so the developer can fix them manually.

## If no linter is found

Tell the user: "No linter configuration detected in this project. Consider adding one (ESLint, Biome, Ruff, etc.)."
