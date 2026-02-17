#!/bin/bash
# Check for sre plugin updates — runs on SessionStart
# Exit 0 always — informational only, never blocks session

LATEST=$(gh release view --repo jdiegosierra/sre-agent-plugin --json tagName -q .tagName 2>/dev/null | sed 's/^v//')

if [ -z "$LATEST" ]; then
  exit 0
fi

# Get the highest installed version (sort -V handles semver correctly)
CURRENT=$(find ~/.claude/plugins/cache -name "plugin.json" -path "*sre*" -exec jq -r .version {} \; 2>/dev/null | sort -V | tail -1)

if [ -z "$CURRENT" ]; then
  exit 0
fi

if [ "$CURRENT" != "$LATEST" ]; then
  MSG="sre plugin update available: v${CURRENT} → v${LATEST}. Run /sre:update to upgrade."
  CONTEXT="IMPORTANT: Inform the user once that an sre plugin update is available (v${CURRENT} → v${LATEST}). Tell them to run /sre:update to upgrade."
  echo "{\"systemMessage\":\"${MSG}\",\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"${CONTEXT}\"}}"
fi

exit 0
