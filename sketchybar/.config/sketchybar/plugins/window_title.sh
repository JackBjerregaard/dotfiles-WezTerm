#!/usr/bin/env bash

# Title of the focused window.
#
# Was: yabai -m query --windows --window | jq -r '.title'
# AeroSpace exposes the same thing without needing jq.

TITLE=$(aerospace list-windows --focused --format '%{window-title}' 2>/dev/null)

if [ -n "$TITLE" ] && [ "${#TITLE}" -gt 1 ]; then
  [ "${#TITLE}" -gt 50 ] && TITLE="${TITLE:0:50}…"
  sketchybar --set "$NAME" drawing=on label="  ›  $TITLE"
else
  sketchybar --set "$NAME" drawing=off
fi
