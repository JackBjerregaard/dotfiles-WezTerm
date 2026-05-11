#!/usr/bin/env bash

ASSERTIONS_FILE="$HOME/Library/DoNotDisturb/DB/Assertions.json"

ASSERTIONS=$(jq '.data[0].storeAssertionRecords | length' "$ASSERTIONS_FILE" 2>/dev/null || echo 0)

if [ "${ASSERTIONS:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
