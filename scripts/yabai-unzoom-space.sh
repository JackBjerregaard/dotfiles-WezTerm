#!/usr/bin/env bash

set -euo pipefail

window_id="${1:-}"
space_index="${2:-}"

if [ -n "$window_id" ]; then
  attempts="${YABAI_UNZOOM_ATTEMPTS:-10}"
  delay="${YABAI_UNZOOM_DELAY:-0.03}"
  i=0

  while [ "$i" -lt "$attempts" ]; do
    window_json="$(yabai -m query --windows --window "$window_id" 2>/dev/null || true)"
    [ -n "$window_json" ] || {
      i=$((i + 1))
      sleep "$delay"
      continue
    }

    should_unzoom="$(
      jq -r '
        select(.role == "AXWindow")
        | select(."is-minimized" == false and ."is-hidden" == false)
        | select(."is-floating" == false)
        | .space // empty
      ' <<<"$window_json"
    )"

    if [ -n "$should_unzoom" ]; then
      space_index="$should_unzoom"
    fi

    break
  done

  [ -n "$space_index" ] || exit 0
fi

if [ -z "$space_index" ]; then
  space_index="$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty')" || true
fi

[ -n "$space_index" ] || exit 0

yabai -m query --windows --space "$space_index" 2>/dev/null |
  jq -r '.[] | select(."has-fullscreen-zoom" == true) | .id' |
  while read -r zoomed_window_id; do
    [ -n "$zoomed_window_id" ] || continue
    yabai -m window "$zoomed_window_id" --toggle zoom-fullscreen >/dev/null 2>&1 || true
  done
