#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"
mode="${2:-}"

case "$target" in
  prev | next) ;;
  *)
    echo "usage: $0 <prev|next> [--follow]" >&2
    exit 2
    ;;
esac

if [ -n "$mode" ] && [ "$mode" != "--follow" ]; then
  echo "usage: $0 <prev|next> [--follow]" >&2
  exit 2
fi

window_id="$(yabai -m query --windows --window | jq -r '.id // empty')"

if [ -z "$window_id" ]; then
  exit 0
fi

# Moving past the first/last space has nowhere to go (spaces are static, so
# there is no wrap-around and nothing to create). Do nothing rather than abort
# under `set -e`.
if ! yabai -m window "$window_id" --space "$target" 2>/dev/null; then
  exit 0
fi

if [ "$mode" = "--follow" ]; then
  yabai -m space --focus "$target"
  "$HOME/dotfiles/scripts/yabai-focus-current-space-window.sh" "$window_id"
fi
