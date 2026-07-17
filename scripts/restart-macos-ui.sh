#!/usr/bin/env bash
set -u

uid="$(id -u)"

restart_agent() {
  local label="$1"

  if launchctl print "gui/$uid/$label" >/dev/null 2>&1; then
    echo "restarting $label"
    launchctl kickstart -k "gui/$uid/$label"
  else
    echo "skipping $label (not loaded)"
  fi
}

restart_agent com.asmvik.yabai
restart_agent com.koekeishiya.skhd
restart_agent homebrew.mxcl.sketchybar

sleep 1

if command -v yabai >/dev/null 2>&1; then
  if yabai -m query --spaces >/dev/null 2>&1; then
    echo "yabai socket ok"
  else
    echo "warning: yabai is running but its socket is not responding" >&2
  fi
fi

if command -v sketchybar >/dev/null 2>&1; then
  sketchybar --reload >/dev/null 2>&1 || true
  echo "sketchybar reload requested"
fi
