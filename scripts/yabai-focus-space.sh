#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"
minimum="${YABAI_MIN_SPACES:-9}"

if ! [[ "$target" =~ ^[0-9]+$ ]]; then
  echo "usage: $0 <space-index>" >&2
  exit 2
fi

space_exists() {
  yabai -m query --spaces | jq -e --argjson target "$1" 'any(.[]; .index == $target)' >/dev/null
}

# Creating spaces needs the scripting addition. Tolerate it failing so that
# focusing a space that already exists still works when the addition is not
# loaded, instead of aborting under `set -e` before the focus below.
"$HOME/dotfiles/scripts/yabai-ensure-min-spaces.sh" "$minimum" 2>/dev/null || true

while ! space_exists "$target"; do
  yabai -m space --create 2>/dev/null || break
done

space_exists "$target" || exit 0

yabai -m space --focus "$target"

# No yabai-focus-current-space-window.sh call here on purpose. The space_changed
# signal already focuses a window on the destination, and it fires late enough to
# see the new space. Calling it here instead races the transition: for the first
# ~60ms `yabai -m query --spaces --space` still reports the *old* space, so the
# script would focus a window back there and macOS would follow it, bouncing us
# out of the space we just asked for.
