# sre-agent-plugin

Claude Code plugin with SRE tools, standards, and integrations.

## What's included

| Component | Name | Description |
|-----------|------|-------------|
| Agent | `sre` | Orchestrates PR workflow, linting, testing, and GitHub management |
| MCP | `github` | GitHub MCP server for repo, PR, and issue management |
| Command | `lint-fix` | Detects the project linter and runs autofix |
| Command | `run-tests` | Detects the project test framework and runs the suite |
| Command | `update` | Check for plugin updates and install the latest version |
| Command | `statusline` | Configure the context monitor statusline |
| Skill | `pull-request-standards` | PR title, description, and branch naming conventions |
| Skill | `helm-charts-best-practices` | Helm chart architecture, patterns, and best practices |
| Hook | Update check | Notifies on session start if a newer plugin version is available |
| Hook | Stop notification | Desktop notification when Claude Code finishes a response |

## Prerequisites

- **Docker** — the GitHub MCP server runs as a container
- **gh** — GitHub CLI ([install](https://cli.github.com/)) — used by the update check hook

### Environment variables

Add these to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
# GitHub (required for the GitHub MCP)
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here"
```

> MCP servers are registered automatically when the plugin is installed. Binaries are downloaded on-demand the first time each MCP is used — no manual setup required.

## Installation

### 1. Add the marketplace

```
/plugin marketplace add jdiegosierra/sre-agent-plugin
```

### 2. Install the plugin

```
/plugin install sre@jdiegosierra/sre-agent-plugin
```

This installs the plugin globally — it works across all your projects.

## Usage

Once installed, the plugin adds commands, skills, and an agent to Claude Code. You interact with them through natural language or slash commands inside Claude Code.

### Create a PR (full pipeline)

Just ask Claude:

```
Create a pull request for the current branch
```

The `sre` agent runs the full pipeline automatically:

```
validate branch → commit pending changes → lint fix → run tests → push → create PR
```

If lint or tests fail, the agent stops and reports what needs fixing.

### Available commands

All commands are invoked inside Claude Code with `/sre:<name>`:

| Command | Description |
|---------|-------------|
| `/sre:lint-fix` | Detect the project linter and run with autofix |
| `/sre:run-tests` | Detect the test framework and run the suite |
| `/sre:update` | Check for plugin updates and install the latest version |
| `/sre:statusline` | Configure the context monitor statusline |

You can also invoke them naturally — e.g., _"run the tests"_ or _"configure the statusline"_ — and the agent will use the right command.

### Plugin updates

The plugin checks for updates on session start. If a newer version is available, you'll see a message recommending `/sre:update`.

## Project structure

```
sre-agent-plugin/
├── .claude-plugin/
│   ├── plugin.json                    # Plugin manifest (name, version, MCPs)
│   └── marketplace.json               # Marketplace metadata
├── agents/
│   └── sre.md                         # Orchestrator: PR workflow + GitHub
├── commands/
│   ├── lint-fix.md                    # Linter detection and autofix
│   ├── run-tests.md                   # Test framework detection and execution
│   ├── statusline.md                  # Context monitor statusline setup
│   └── update.md                      # Plugin update check
├── hooks/
│   ├── hooks.json                     # Hook definitions (update check, notification)
│   ├── check-update.sh                # Version comparison script
│   ├── notify.sh                      # Desktop notification on stop
│   └── assets/
│       └── icon.png                   # Notification icon
├── scripts/
│   └── context-monitor.py             # Statusline context monitor
├── skills/
│   ├── helm-charts-best-practices/
│   │   └── SKILL.md                   # Helm chart patterns and best practices
│   └── pull-request-standards/
│       └── SKILL.md                   # PR standards and conventions
├── AGENTS.md                          # Claude Code project instructions
├── CLAUDE.md -> AGENTS.md             # Symlink for Claude Code
└── README.md
```

## PR standards enforced

The `pull-request-standards` skill enforces:

- **Branch naming**: `<type>/<ticket-or-description>` (e.g., `feat/PROJ-123-add-auth`)
- **PR title**: Conventional Commits format — `type(scope): description`
- **PR description**: Must include Summary, Changes, How to test, and Related issues sections
- **Issue linking**: Uses closing keywords (`Closes`, `Fixes`, `Resolves`)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

[MIT](LICENSE)
