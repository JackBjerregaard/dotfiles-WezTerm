#!/usr/bin/env bash

set -euo pipefail

sleep "${YABAI_FOCUS_DELAY:-0.05}"

space_index="$(yabai -m query --spaces --space | jq -r '.index // empty')"

if [ -z "$space_index" ]; then
  exit 0
fi

window_id="$(
  yabai -m query --windows --space "$space_index" |
    jq -r '[.[] | select(."is-minimized" == false and ."is-hidden" == false)] | last.id // empty'
)"

if [ -z "$window_id" ]; then
  exit 0
fi

yabai -m window --focus "$window_id" >/dev/null 2>&1 || true
