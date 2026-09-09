#!/usr/bin/env bash
set -u

# Reload the window manager and status bar. Bound to `ctrl + alt - r` in
# aerospace.toml, and to the `restart-dots` / `restart-wm` shell aliases.
#
# This used to be a 47-line launchctl dance. yabai and skhd ran as launchd user
# agents, and `--stop-service` did not merely unload them — it ran
# `launchctl disable`, which writes to a *persistent* override database that
# survives reboots. `launchctl kickstart` cannot revive a disabled service, so
# the old script's recovery path silently did nothing in exactly the situation
# it existed for, and needed an explicit `--start-service` fallback.
#
# AeroSpace is an ordinary application with start-at-login in its own config.
# There is no service database, so there is nothing to get stuck.

if pgrep -x AeroSpace >/dev/null 2>&1; then
  echo "reloading AeroSpace config"
  aerospace reload-config || echo "warning: config reload failed — see the error above" >&2
else
  echo "AeroSpace not running; starting it"
  open -a AeroSpace || echo "warning: could not start AeroSpace" >&2
  sleep 2
fi

if focused="$(aerospace list-workspaces --focused 2>/dev/null)" && [ -n "$focused" ]; then
  echo "aerospace ok (focused workspace: $focused)"
else
  echo "warning: AeroSpace is not responding." >&2
  echo "         Check System Settings > Privacy & Security > Accessibility." >&2
fi

if command -v sketchybar >/dev/null 2>&1; then
  sketchybar --reload >/dev/null 2>&1 || true
  echo "sketchybar reload requested"
fi

# If windows keep landing on the wrong screen after a workspace switch, it is
# almost always leftover macOS Spaces. This prints the fix when that is the case.
"$(dirname "${BASH_SOURCE[0]}")/aerospace-check-spaces.sh" --quiet || true
