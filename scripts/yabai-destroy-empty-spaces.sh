#!/usr/bin/env bash
set -euo pipefail

occupied_spaces="$(
  yabai -m query --windows |
    jq -r '
      .[]
      | select(.role == "AXWindow")
      | select(."is-minimized" == false and ."is-hidden" == false)
      | select((.app != "Finder") or ((.title // "") | length > 0))
      | .space
    ' |
    sort -nu
)"

yabai -m query --spaces |
  jq -r --arg occupied_spaces "$occupied_spaces" '
    ($occupied_spaces | split("\n") | map(select(length > 0) | tonumber)) as $occupied
    | .[]
    | select(.index as $space | ($occupied | index($space) | not))
    | .index
  ' |
  sort -rn |
  while read -r space; do
    [[ -n "$space" ]] || continue
    yabai -m space "$space" --destroy || true
  done

command -v sketchybar >/dev/null && sketchybar --reload
"$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh"
