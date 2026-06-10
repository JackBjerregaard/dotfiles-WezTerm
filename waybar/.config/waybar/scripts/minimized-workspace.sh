#!/usr/bin/env sh

[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || exit 0

count="$(
  hyprctl clients -j 2>/dev/null \
    | jq '[.[] | select(.workspace.name == "special:minimized")] | length'
)"

if [ "$count" -eq 0 ]; then
  printf '{"text":"","class":"hidden","tooltip":""}\n'
  exit 0
fi

visible="$(
  hyprctl monitors -j 2>/dev/null \
    | jq -r 'map(select(.specialWorkspace.name == "special:minimized")) | length > 0'
)"

if [ "$visible" = "true" ]; then
  printf '{"text":"min %s","class":"visible","tooltip":"%s minimized window(s) — scratchpad open"}\n' "$count" "$count"
else
  printf '{"text":"min %s","class":"has-minimized","tooltip":"%s minimized window(s)"}\n' "$count" "$count"
fi
