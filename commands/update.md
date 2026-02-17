---
description: Check for sre plugin updates and install the latest version
---

You must check if there is a newer version of the sre plugin and update it if needed. This is a direct action.

## Steps

### 1. Get the current installed version

Find and read the installed plugin.json:

```bash
find ~/.claude/plugins -name "plugin.json" -path "*sre*" 2>/dev/null -exec cat {} \;
```

Extract the `version` field from the output.

### 2. Get the latest available version

```bash
gh release view --repo jdiegosierra/sre-agent-plugin --json tagName -q .tagName
```

Strip the `v` prefix if present (e.g., `v0.1.0` → `0.1.0`).

If there are no releases yet, tell the user and stop.

### 3. Compare versions

- If the installed version matches the latest, tell the user: **"sre plugin is up to date (vX.Y.Z)"**.
- If the latest version is newer, tell the user: **"Update available: vCURRENT → vLATEST"** and proceed to step 4.
- If you cannot determine the installed version, proceed to step 4 anyway.

### 4. Update the plugin

Ask the user to run this command in their terminal (outside Claude Code):

```
claude plugin update sre@jdiegosierra-sre-agent-plugin
```

> **Note**: `claude plugin update sre` does NOT work — the full name including the marketplace is required.

Then restart their Claude Code session to pick up the changes.
