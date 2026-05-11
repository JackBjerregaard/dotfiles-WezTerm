#!/usr/bin/env bash

set -euo pipefail

preferred_window_id="${1:-}"
attempts="${YABAI_FOCUS_ATTEMPTS:-12}"
delay="${YABAI_FOCUS_DELAY:-0.03}"

focus_window() {
  local window_id="$1"

  [ -n "$window_id" ] || return 1
  yabai -m window --focus "$window_id" >/dev/null 2>&1
}

current_space_window_id() {
  local space_index

  space_index="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty')" || return 1

  [ -n "$space_index" ] || return 1

  yabai -m query --windows --space "$space_index" 2>/dev/null |
    jq -r '
      [
        .[]
        | select(."is-minimized" == false and ."is-hidden" == false)
        | select(.role == "AXWindow")
      ]
      | sort_by(."has-focus")
      | last.id // empty
    '
}

i=0
while [ "$i" -lt "$attempts" ]; do
  if focus_window "$preferred_window_id"; then
    exit 0
  fi

  window_id="$(current_space_window_id || true)"
  if focus_window "$window_id"; then
    exit 0
  fi

  i=$((i + 1))
  sleep "$delay"
done

exit 0
