# Contributing to sre-agent-plugin

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to be respectful and constructive in all interactions.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with the bug report template. Include:

1. A clear, descriptive title
2. Steps to reproduce the issue
3. Expected behavior vs actual behavior
4. Your environment (Claude Code version, OS, etc.)

### Suggesting Features

Feature requests are welcome! Please open an issue with the feature request template.

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Make your changes
4. Test locally (see below)
5. Commit your changes using [Conventional Commits](#commit-conventions)
6. Push to your branch
7. Open a Pull Request

## Development Setup

This is a Claude Code plugin — there is no build step, no dependencies to install, and no test suite to run. The plugin is composed of markdown files, JSON configs, and shell scripts.

### Testing locally

To test the plugin without installing it from the marketplace:

```bash
# Clone the repository
git clone https://github.com/jdiegosierra/sre-agent-plugin.git
cd sre-agent-plugin

# Run Claude Code with the plugin loaded from the local directory
claude --plugin-dir ./
```

This loads the plugin directly from your working directory. Any changes you make to the files are picked up immediately (restart Claude Code to apply).

### Project structure

| Directory | Purpose |
|---|---|
| `.claude-plugin/` | Plugin manifest and marketplace metadata |
| `agents/` | Subagent definitions (markdown with YAML frontmatter) |
| `commands/` | Direct-action commands invoked via `/sre:<name>` |
| `skills/` | Skills with standards/reference docs (each is a folder with `SKILL.md`) |
| `hooks/` | Lifecycle hooks (JSON config + scripts) |
| `scripts/` | Supporting scripts used by commands and hooks |

### Adding a new component

- **Command**: Create `commands/<name>.md` with a `description` in the YAML frontmatter.
- **Skill**: Create `skills/<name>/SKILL.md` with `name` and `description` in the YAML frontmatter.
- **Agent**: Create `agents/<name>.md` with `name` and `description` in the YAML frontmatter.
- **Hook**: Edit `hooks/hooks.json` and add to the relevant event array.
- **MCP server**: Add to `mcpServers` in `.claude-plugin/plugin.json`. Use `${ENV_VAR}` for secrets.

## Commit Conventions

This project uses **Conventional Commits** strictly. Release-please parses them to generate changelogs and version bumps.

- `feat:` — new feature (minor version bump)
- `fix:` — bug fix (patch version bump)
- `feat!:` or `BREAKING CHANGE` — breaking change (major version bump)
- `docs:` — documentation only (no version bump)
- `chore:` — maintenance (no version bump)
- `ci:` — CI/CD changes (no version bump)

Examples:
- `feat: add new helm validation command`
- `fix: correct update check for renamed plugins`
- `docs: add troubleshooting section to README`

## Pull Request Guidelines

- Keep PRs focused on a single change
- Follow the PR title format: `type(scope): description`
- Include a Summary, Changes, and How to test section in the description
- Ensure the PR targets the `main` branch

## Release Process

Releases are automated via [release-please](https://github.com/googleapis/release-please). When PRs are merged to `main`:

1. Release-please creates/updates a release PR
2. Merging the release PR bumps the version, updates the changelog, and creates a GitHub release
3. Users update via `/sre:update`

## Questions?

If you have questions, feel free to open an issue or start a discussion.

Thank you for contributing!
