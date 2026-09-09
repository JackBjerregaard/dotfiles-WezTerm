#!/usr/bin/env bash
set -u

# Warn when a connected display has more than one regular macOS Space.
#
# Why this matters
# ----------------
# AeroSpace does not use macOS Spaces. It tiles by moving windows off-screen
# *within whatever single Space is currently active*. If a display has several
# regular desktops, windows opened while a different desktop was frontmost get
# physically stranded on that desktop, and `aerospace workspace N` — which only
# rearranges windows on the active Space — cannot pull them across. The symptom
# is a workspace switch that lands on an empty screen while
# `aerospace list-windows` insists the window is right there: a split brain
# between AeroSpace's workspace model and macOS's Space model.
#
# The five leftover desktops this repo hit in Sept 2026 were `type = 0` regular
# desktops left behind by the old yabai static-nine-space model (commit
# 9248763). macOS native fullscreen also makes a Space, but a transient
# `type = 4` one that is destroyed on exit, so it does not accumulate and is
# not counted here.
#
# There is no non-SIP CLI to delete a Space — that was yabai's scripting
# addition. The fix is manual and one-time; this script only tells you it is
# needed.
#
# Usage:
#   ./aerospace-check-spaces.sh          # print health line, exit 0/1
#   ./aerospace-check-spaces.sh --quiet  # print only on a problem (for install)

plist="$HOME/Library/Preferences/com.apple.spaces.plist"
quiet=0
[ "${1:-}" = "--quiet" ] && quiet=1

if [ ! -r "$plist" ]; then
  [ "$quiet" -eq 1 ] || echo "aerospace-check-spaces: $plist not readable — skipping"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  [ "$quiet" -eq 1 ] || echo "aerospace-check-spaces: jq not installed — skipping"
  exit 0
fi

# Connected displays are the Monitors entries that carry a `Spaces` array;
# disconnected ones only have a `Collapsed Space`. Count regular (type 0)
# desktops per connected display.
counts="$(
  plutil -convert json -o - "$plist" 2>/dev/null | jq -r '
    ."SpacesDisplayConfiguration"."Management Data".Monitors[]
    | select(.Spaces)
    | [ (."Display Identifier"), ([ .Spaces[] | select(.type == 0) ] | length) ]
    | @tsv
  '
)"

if [ -z "$counts" ]; then
  [ "$quiet" -eq 1 ] || echo "aerospace-check-spaces: could not parse Spaces config — skipping"
  exit 0
fi

worst=1
while IFS=$'\t' read -r display n; do
  [ -z "${n:-}" ] && continue
  [ "$n" -gt "$worst" ] && worst="$n"
  if [ "$quiet" -eq 0 ]; then
    if [ "$n" -gt 1 ]; then
      echo "  display $display: $n regular desktops  <-- should be 1"
    else
      echo "  display $display: 1 desktop  ok"
    fi
  fi
done <<< "$counts"

if [ "$worst" -le 1 ]; then
  [ "$quiet" -eq 1 ] || echo "aerospace-check-spaces: one Space per display — ok"
  exit 0
fi

cat >&2 <<'EOF'

[WARN] A display has more than one macOS Space (Mission Control desktop).

  AeroSpace expects exactly one Space per monitor. With more than one, windows
  get stranded on other desktops and `ctrl + 1..9` lands on an empty screen
  while `aerospace list-windows` still shows the window. There is no CLI to
  remove a Space without disabling SIP.

  Fix (one-time, ~20 seconds):
    1. Open Mission Control  (F3, or Control + Up).
    2. In the desktop strip along the top, hover each extra desktop and click
       the small x. Leave exactly one.
    3. Do not use "Add a Desktop" or macOS native fullscreen-and-leave-it.
       hyper + f (fullscreen --no-outer-gaps) fills the screen without a Space.

  See aerospace/WORKSPACES.md > "Windows on the wrong Mission Control desktop".
EOF
exit 1
