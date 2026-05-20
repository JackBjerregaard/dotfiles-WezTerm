#!/usr/bin/env sh

hyprctl clients -j | jq -r '.[].address' | while IFS= read -r address; do
  [ -n "$address" ] || continue
  hyprctl dispatch closewindow "address:$address"
done

sleep 0.5

uid="$(id -u)"
discord_pattern='(^|/)(Discord|discord|DiscordCanary|discordcanary|DiscordPTB|discordptb)([[:space:]]|$)'

pkill -TERM -u "$uid" -f "$discord_pattern" 2>/dev/null

tries=0
while pgrep -u "$uid" -f "$discord_pattern" >/dev/null 2>&1 && [ "$tries" -lt 20 ]; do
  tries=$((tries + 1))
  sleep 0.1
done

if pgrep -u "$uid" -f "$discord_pattern" >/dev/null 2>&1; then
  pkill -KILL -u "$uid" -f "$discord_pattern" 2>/dev/null
fi
