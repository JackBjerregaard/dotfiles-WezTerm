#!/usr/bin/env sh

hyprctl clients -j | jq -r '.[].address' | while IFS= read -r address; do
  [ -n "$address" ] || continue
  hyprctl dispatch closewindow "address:$address"
done

sleep 0.2

for process in Discord discord DiscordCanary discordcanary DiscordPTB discordptb; do
  pkill -TERM -x "$process" 2>/dev/null
done
