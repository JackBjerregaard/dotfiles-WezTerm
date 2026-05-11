#!/usr/bin/env bash
set -euo pipefail

yabai -m query --spaces \
  | jq -r '.[] | select((.windows | length) == 0) | .index' \
  | sort -rn \
  | while read -r space; do
      [[ -n "$space" ]] || continue
      yabai -m space "$space" --destroy || true
    done

command -v sketchybar >/dev/null && sketchybar --reload
"$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh"
