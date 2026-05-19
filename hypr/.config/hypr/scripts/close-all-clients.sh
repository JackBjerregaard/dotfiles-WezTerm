#!/usr/bin/env sh

hyprctl clients -j | jq -r '.[].address' | while IFS= read -r address; do
  [ -n "$address" ] || continue
  hyprctl dispatch closewindow "address:$address"
done
