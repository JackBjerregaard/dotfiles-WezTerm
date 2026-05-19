#!/usr/bin/env sh

if [ "$(hyprctl clients -j | jq 'length')" -eq 0 ]; then
  hyprctl dispatch exit
fi
