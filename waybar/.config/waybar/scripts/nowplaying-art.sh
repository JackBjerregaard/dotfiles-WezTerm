#!/usr/bin/env bash

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-nowplaying"
CACHE_FILE="$CACHE_DIR/art.jpg"
LAST_URL_FILE="$CACHE_DIR/last_url"
TIMEOUT=2

command -v playerctl >/dev/null 2>&1 || exit 0
command -v curl >/dev/null 2>&1 || exit 0

if command -v imv >/dev/null 2>&1; then
  VIEWER="imv"
elif command -v swayimg >/dev/null 2>&1; then
  VIEWER="swayimg"
elif command -v xdg-open >/dev/null 2>&1; then
  VIEWER="xdg-open"
else
  exit 0
fi

mkdir -p "$CACHE_DIR"

ART_URL="$(playerctl metadata mpris:artUrl 2>/dev/null || true)"
[ -n "$ART_URL" ] || exit 0

if [ ! -f "$CACHE_FILE" ] || [ ! -f "$LAST_URL_FILE" ] || [ "$(cat "$LAST_URL_FILE")" != "$ART_URL" ]; then
  curl -fsSL "$ART_URL" -o "$CACHE_FILE" || exit 0
  printf '%s\n' "$ART_URL" > "$LAST_URL_FILE"
fi

"$VIEWER" "$CACHE_FILE" &
IMV_PID=$!

if [ "$VIEWER" != "xdg-open" ]; then
  (
    sleep "$TIMEOUT"
    kill "$IMV_PID" 2>/dev/null || true
  ) &
fi
