#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"

if ! [[ "$target" =~ ^[0-9]+$ ]]; then
  echo "usage: $0 <space-index>" >&2
  exit 2
fi

window_id="$(yabai -m query --windows --window | jq -r '.id // empty')"

if [ -z "$window_id" ]; then
  exit 0
fi

created_space=false

while ! yabai -m query --spaces | jq -e --argjson target "$target" 'any(.[]; .index == $target)' >/dev/null; do
  yabai -m space --create
  created_space=true
done

yabai -m window "$window_id" --space "$target"
yabai -m space --focus "$target"
yabai -m window --focus "$window_id"

if [ "$created_space" = true ] && command -v sketchybar >/dev/null; then
  sketchybar --reload
fi
