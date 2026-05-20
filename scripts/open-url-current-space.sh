#!/usr/bin/env bash

set -euo pipefail

app_name="${1:-}"
app_path="${2:-}"
url="${3:-}"

if [ -z "$app_name" ] || [ -z "$url" ]; then
  echo "usage: $0 <app-name> <app-path> <url>" >&2
  exit 2
fi

current_space="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty')"

if [ -z "$current_space" ]; then
  open -na "$app_path" --args --new-window "$url"
  exit 0
fi

"$HOME/dotfiles/scripts/yabai-unzoom-space.sh" "" "$current_space"

existing_window_ids="$(
  yabai -m query --windows 2>/dev/null |
    jq -c --arg app_name "$app_name" '[.[] | select(.app == $app_name) | .id]' 2>/dev/null ||
    printf '[]'
)"

open -na "$app_path" --args --new-window "$url"

attempts="${OPEN_APP_LAUNCH_ATTEMPTS:-40}"
delay="${OPEN_APP_LAUNCH_DELAY:-0.05}"
i=0

while [ "$i" -lt "$attempts" ]; do
  window_id="$(
    yabai -m query --windows 2>/dev/null |
      jq -r \
        --arg app_name "$app_name" \
        --argjson current_space "$current_space" \
        --argjson existing "$existing_window_ids" '
          [
            .[]
            | select(.app == $app_name)
            | select(.role == "AXWindow")
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
    exit 0
  fi

  i=$((i + 1))
  sleep "$delay"
done

yabai -m space --focus "$current_space" >/dev/null 2>&1 || true
"$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh"
