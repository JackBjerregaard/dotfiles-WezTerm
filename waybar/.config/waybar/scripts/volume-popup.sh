#!/usr/bin/env bash

set -euo pipefail

if ! command -v rofi >/dev/null 2>&1 || ! command -v pamixer >/dev/null 2>&1; then
  exit 0
fi

if ! current="$(pamixer --get-volume 2>/dev/null)"; then
  printf 'Audio unavailable\n' | rofi -dmenu -p 'Volume' -theme-str 'window { width: 260px; } listview { lines: 1; }' >/dev/null
  exit 0
fi

muted="$(pamixer --get-mute 2>/dev/null || printf 'false')"
mute_label="󰝟  Mute"
if [ "$muted" = "true" ]; then
  mute_label="󰕿  Unmute"
fi

choice="$(
  {
    printf '%s\n' "$mute_label"
    printf '  -5%%\n'
    printf '  +5%%\n'
    for value in 0 10 20 30 40 50 60 70 80 90 100; do
      filled=$((value / 10))
      empty=$((10 - filled))
      bar="$(printf '%*s' "$filled" '' | tr ' ' '━')$(printf '%*s' "$empty" '' | tr ' ' '─')"
      printf '󰕾  %3d%%  %s\n' "$value" "$bar"
    done
  } | rofi -dmenu -i -p "Volume ${current}%" \
      -theme-str 'window { width: 340px; } listview { lines: 8; } element { padding: 6px 10px; } entry { enabled: false; }'
)"

case "$choice" in
  *Mute|*Unmute)
    pamixer -t
    ;;
  *'-5%'*)
    pamixer -d 5
    ;;
  *'+5%'*)
    pamixer -i 5
    ;;
  *'% '*)
    volume="$(printf '%s' "$choice" | sed -n 's/.* \([0-9][0-9]*\)%.*/\1/p')"
    [ -n "$volume" ] && pamixer --set-volume "$volume"
    ;;
esac
