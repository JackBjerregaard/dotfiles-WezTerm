#!/usr/bin/env bash
set -euo pipefail

window_json="$(hyprctl -j activewindow 2>/dev/null || true)"

if ! jq -e . >/dev/null 2>&1 <<<"$window_json"; then
  window_json="{}"
fi

if [[ -z "$window_json" || "$window_json" == "null" || "$window_json" == "{}" ]]; then
  jq -cn --arg text "󰖲 Desktop" --arg tooltip "No focused application" \
    '{text: $text, tooltip: $tooltip, class: "empty"}'
  exit 0
fi

class="$(jq -r '.class // empty' <<<"$window_json")"
title="$(jq -r '.title // empty' <<<"$window_json")"

case "${class,,}" in
  *chrome* | *chromium*) icon="" ;;
  *brave*) icon="󰖟" ;;
  *firefox*) icon="" ;;
  *wezterm* | *kitty* | *alacritty* | *foot* | *terminal*) icon="" ;;
  *code* | *codium*) icon="󰨞" ;;
  *discord*) icon="󰙯" ;;
  *spotify*) icon="" ;;
  *steam*) icon="" ;;
  *thunar* | *nautilus* | *dolphin*) icon="" ;;
  *pavucontrol*) icon="" ;;
  *rofi*) icon="󰍉" ;;
  *) icon="󰣆" ;;
esac

name="$class"
if [[ -z "$name" ]]; then
  name="Application"
fi

label="$name"
if [[ -n "$title" && "$title" != "$name" ]]; then
  label="$name - $title"
fi

jq -cn \
  --arg text "$icon $label" \
  --arg tooltip "$label" \
  --arg class "${class,,}" \
  '{text: $text, tooltip: $tooltip, class: $class}'
