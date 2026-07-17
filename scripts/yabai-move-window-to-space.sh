#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"
mode="${2:-}"

if ! [[ "$target" =~ ^[0-9]+$ ]]; then
  echo "usage: $0 <space-index> [--follow]" >&2
  exit 2
fi

if [ -n "$mode" ] && [ "$mode" != "--follow" ]; then
  echo "usage: $0 <space-index> [--follow]" >&2
  exit 2
fi

window_id="$(yabai -m query --windows --window | jq -r '.id // empty')"

if [ -z "$window_id" ]; then
  exit 0
fi

created_space=false

space_exists() {
  yabai -m query --spaces | jq -e --argjson target "$1" 'any(.[]; .index == $target)' >/dev/null
}

# Creating spaces needs the scripting addition (SIP). Tolerate it failing so a
# missing target degrades to "do nothing" with a reason, rather than aborting
# under `set -e` with no output.
while ! space_exists "$target"; do
  if ! yabai -m space --create 2>/dev/null; then
    echo "yabai-move-window-to-space: space $target does not exist and --create" \
      "needs the scripting addition; create it via Mission Control" >&2
    exit 0
  fi
  created_space=true
done

yabai -m window "$window_id" --space "$target"

if [ "$mode" = "--follow" ]; then
  yabai -m space --focus "$target"
  "$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh" "$window_id"
fi

if [ "$created_space" = true ] && command -v sketchybar >/dev/null; then
  sketchybar --reload
fi
