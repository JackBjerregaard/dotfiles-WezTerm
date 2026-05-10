#!/usr/bin/env bash

TITLE=$(yabai -m query --windows --window 2>/dev/null | jq -r '.title // empty')

if [ -n "$TITLE" ] && [ "${#TITLE}" -gt 1 ]; then
  [ "${#TITLE}" -gt 50 ] && TITLE="${TITLE:0:50}…"
  sketchybar --set "$NAME" drawing=on label="  ›  $TITLE"
else
  sketchybar --set "$NAME" drawing=off
fi
