#!/bin/bash
# Desktop notification with conversation context
# Uses terminal-notifier if available, falls back to osascript (macOS) or notify-send (Linux)
#
# Reads Stop hook stdin JSON to extract:
#   - cwd: project directory (used in title)
#   - transcript_path: JSONL file (first user message used as topic)
#   - stop_hook_active: prevents infinite loops

INPUT=$(cat)

# Prevent infinite loops if this hook triggers another Stop
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)
[ "$STOP_ACTIVE" = "true" ] && exit 0

# Extract project name from working directory
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
PROJECT=$(basename "${CWD:-$PWD}")

# Try to extract the first real user message as conversation topic
TOPIC=""
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Transcript is JSONL with .type == "user" and .message.content (string or array)
  # Skip system/command messages (contain <command-message> or null)
  TOPIC=$(head -30 "$TRANSCRIPT" \
    | jq -r 'select(.type == "user")
      | .message.content
      | if type == "array" then map(select(.type == "text")) | .[0].text
        else .
        end
      // empty' 2>/dev/null \
    | grep -v '<command-' \
    | grep -v '^null$' \
    | grep -v '^\s*$' \
    | head -1)
  # Truncate long messages to fit in a notification
  if [ "${#TOPIC}" -gt 80 ]; then
    TOPIC="${TOPIC:0:77}..."
  fi
fi

# Build notification
TITLE="Claude Code · $PROJECT"
if [ -n "$TOPIC" ]; then
  MESSAGE="$TOPIC"
else
  MESSAGE="Response complete"
fi

# Resolve icon path relative to the script location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ICON="$SCRIPT_DIR/assets/icon.png"

# Send notification
if command -v terminal-notifier >/dev/null 2>&1; then
  # -group with unique ID prevents macOS from suppressing repeated notifications
  ARGS=(-title "$TITLE" -message "$MESSAGE" -group "claude-$$-$(date +%s)")
  [ -f "$ICON" ] && ARGS+=(-appIcon "$ICON" -contentImage "$ICON")
  terminal-notifier "${ARGS[@]}"
elif command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "$TITLE" "$MESSAGE"
fi
