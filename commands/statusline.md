---
description: Configure the statusline with context monitor, git info, and session metrics
---

You must configure the user's statusline to use the context monitor. This is a direct action.

The statusline script is bundled with the plugin at `scripts/context-monitor.py`. It shows: model name, directory, git branch with change count, context window usage with visual progress bar, and session metrics (cost, duration, lines changed).

## Steps

### 1. Locate the plugin root

```bash
find ~/.claude/plugins -name "plugin.json" -path "*sre*" 2>/dev/null -exec dirname {} \; | head -1
```

The plugin root is the **parent** of the directory containing `plugin.json` (go up one level from `.claude-plugin/`). Verify that `scripts/context-monitor.py` exists there.

### 2. Check current statusline config

Read `~/.claude/settings.json` to see if a `statusLine` is already configured.

- If one exists, show the user the current config and ask if they want to replace it.
- If none exists, proceed to step 3.

### 3. Apply the statusline

Add or replace the `statusLine` key in `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "python3 \"<PLUGIN_ROOT>/scripts/context-monitor.py\""
  }
}
```

Replace `<PLUGIN_ROOT>` with the absolute path found in step 1.

**Important**: Merge into the existing file — do NOT overwrite other settings.

### 4. Confirm

Tell the user: **"Statusline configured. Restart Claude Code to see it."**

Briefly describe what the statusline shows:
- Model name (color changes with context usage)
- Current directory
- Git branch + uncommitted change count (red = dirty, green = clean)
- Context window usage with progress bar and alerts
- Session cost, duration, and net lines changed
