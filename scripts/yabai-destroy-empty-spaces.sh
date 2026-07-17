#!/usr/bin/env bash
set -euo pipefail

# Destroying spaces needs yabai's scripting addition (SIP partially disabled),
# and is additionally broken on macOS Tahoe even with it loaded:
# https://github.com/asmvik/yabai/issues/2730
#
# With the standard floor of 9 static spaces this is a no-op, since it only
# reaps spaces above the floor. Kept for the case where the floor is lowered or
# the scripting addition becomes available again.
floor="${YABAI_MIN_SPACES:-9}"

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
  jq -r --arg occupied_spaces "$occupied_spaces" --argjson floor "$floor" '
    ($occupied_spaces | split("\n") | map(select(length > 0) | tonumber)) as $occupied
    | .[]
    | select(.index > $floor)
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
"$HOME/dotfiles/scripts/yabai-ensure-min-spaces.sh" "$floor"
