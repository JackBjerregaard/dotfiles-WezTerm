#!/usr/bin/env bash

WEATHER=$(curl -sf "wttr.in/?format=%c+%t" 2>/dev/null | tr -d '\n' | sed 's/+/ /')
[ -z "$WEATHER" ] && WEATHER="No signal"
sketchybar --set "$NAME" label="$WEATHER"
