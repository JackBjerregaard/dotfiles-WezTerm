#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"

case "$target" in
  prev | next) ;;
  *)
    echo "usage: $0 <prev|next>" >&2
    exit 2
    ;;
esac

window_id="$(yabai -m query --windows --window | jq -r '.id // empty')"

if [ -z "$window_id" ]; then
  exit 0
fi

yabai -m window "$window_id" --space "$target"
yabai -m space --focus "$target"
"$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh" "$window_id"
