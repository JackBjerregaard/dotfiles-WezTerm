#!/usr/bin/env bash

set -euo pipefail

current_space="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty')"

if [ -z "$current_space" ]; then
  open -a Safari
  exit 0
fi

existing_window_ids="$(
  yabai -m query --windows 2>/dev/null |
    jq -c '[.[] | select(.app == "Safari") | .id]' 2>/dev/null ||
    printf '[]'
)"

safari_window_count="$(osascript -e 'tell application "Safari" to count windows' 2>/dev/null || printf '0')"
if [ "$safari_window_count" -eq 0 ]; then
  open -na Safari
else
  osascript -e 'tell application "Safari" to make new document'
fi

attempts="${OPEN_APP_LAUNCH_ATTEMPTS:-40}"
delay="${OPEN_APP_LAUNCH_DELAY:-0.05}"
i=0

while [ "$i" -lt "$attempts" ]; do
  window_id="$(
    yabai -m query --windows 2>/dev/null |
      jq -r \
        --argjson current_space "$current_space" \
        --argjson existing "$existing_window_ids" '
          [
            .[]
            | select(.app == "Safari")
            | select(."is-minimized" == false and ."is-hidden" == false)
            | select(.id as $id | ($existing | index($id) | not))
          ]
          | sort_by(if .space == $current_space then 0 else 1 end)
          | first.id // empty
        ' 2>/dev/null || true
  )"

  if [ -n "$window_id" ]; then
    yabai -m window "$window_id" --space "$current_space" >/dev/null 2>&1 || true
    yabai -m space --focus "$current_space" >/dev/null 2>&1 || true
    "$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh" "$window_id"
    osascript -e 'tell application "Safari" to activate' >/dev/null 2>&1 || true
    exit 0
  fi

  i=$((i + 1))
  sleep "$delay"
done

yabai -m space --focus "$current_space" >/dev/null 2>&1 || true
"$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh"
osascript -e 'tell application "Safari" to activate' >/dev/null 2>&1 || true
