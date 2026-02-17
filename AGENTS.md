# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code plugin (`sre`) that provides SRE developer tools: MCP servers, agents, commands, skills, and hooks. Installed globally by developers via `/plugin install`.

## Architecture

This is a **Claude Code plugin**, not a traditional application. There is no build step, no dependencies to install, and no tests to run. The "code" is markdown files and JSON configs that Claude Code loads at runtime.

| Directory | Purpose |
|---|---|
| `.claude-plugin/plugin.json` | Plugin manifest — defines name, version, and MCP servers |
| `agents/` | Subagent definitions (markdown with YAML frontmatter) |
| `commands/` | Direct-action commands invoked via `/sre:<name>` |
| `skills/` | Skills with standards/reference docs (each is a folder with `SKILL.md`) |
| `hooks/` | Lifecycle hooks (JSON config for SessionStart, Stop, etc.) |
| `scripts/` | Supporting scripts used by commands (e.g., statusline) |

### How components relate

- **Agent** (`sre.md`) is the orchestrator — it invokes commands and skills
- **Commands** (`lint-fix`, `run-tests`, `update`, `statusline`) are atomic actions
- **Skills** (`pull-request-standards`, `helm-charts-best-practices`, `sre-engineer`, `kubernetes-specialist`, `terraform-engineer`, `cloud-architect`, `monitoring-expert`, `chaos-engineer`, `devops-engineer`, `security-reviewer`, `secure-code-guardian`, `database-optimizer`, `postgres-pro`, `sql-pro`, `code-reviewer`, `test-master`, `microservices-architect`, `architecture-designer`, `debugging-wizard`) are reference knowledge the agent uses
- **Hooks** run automatically on events (update check, stop notification)
- **MCPs** are external tool servers started by Claude Code on demand
- **Scripts** are supporting files used by commands and hooks

## Commit conventions

This repo uses **Conventional Commits** strictly. Release-please parses them to generate changelogs and version bumps.

- `feat:` → minor bump
- `fix:` → patch bump
- `feat!:` or `BREAKING CHANGE` → major bump
- `chore:`, `docs:`, `ci:`, `refactor:`, `style:`, `test:` → no version bump

## Versioning

Managed by release-please. On push to `main`, it creates/updates a release PR. On merge of that PR, it:
1. Updates `CHANGELOG.md`
2. Bumps version in `.claude-plugin/plugin.json` (via `extra-files` jsonpath)
3. Creates a GitHub release with a git tag

Current version is tracked in `.release-please-manifest.json`.

## When modifying this plugin

- **Adding an MCP**: Add to `mcpServers` in `.claude-plugin/plugin.json`. Use `${ENV_VAR}` for secrets.
- **Adding a command**: Create `commands/<name>.md` with YAML frontmatter (`description` field).
- **Adding a skill**: Create `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`).
- **Adding an agent**: Create `agents/<name>.md` with YAML frontmatter (`name`, `description`).
- **Adding a hook**: Edit `hooks/hooks.json` and add to the `hooks` array.
- **Adding a script**: Place in `scripts/` and reference from commands/hooks.

## Continuous improvement

When you encounter errors, unintuitive behavior, or workarounds during any task:

1. **Document in the relevant skill file** — add the issue and its workaround to the appropriate `SKILL.md`. If there's no suitable skill, add it to the most related file.
2. **Commit the documentation** — use `docs:` prefix for pure documentation, or `fix:` if it accompanies a code change.
3. **Update session memory** — record the finding in your memory files so you don't repeat the same mistakes in future sessions.

This applies to MCP tool bugs, bash escaping issues, API quirks, plugin system gotchas, and anything else that cost time to figure out. The goal is that this project improves with every session.
