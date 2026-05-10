#!/usr/bin/env bash

ASSERTIONS=$(jq '.data[0].storeAssertionRecords | length' \
  ~/Library/DoNotDisturb/DB/Assertions.json 2>/dev/null || echo 0)

if [ "${ASSERTIONS:-0}" -gt 0 ]; then
  MODE=$(jq -r '.data[0].storeAssertionRecords[0].assertionDetails.assertionDetailsModeIdentifier // "Focus"' \
    ~/Library/DoNotDisturb/DB/Assertions.json 2>/dev/null | sed 's/.*\.//')
  MODE="${MODE^}"
  [ -z "$MODE" ] && MODE="Focus"
  sketchybar --set "$NAME" drawing=on label="$MODE"
else
  sketchybar --set "$NAME" drawing=off
fi
