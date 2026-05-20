#!/usr/bin/env sh

[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || exit 0

lock_dir="${XDG_RUNTIME_DIR:-/tmp}/hypr-prune-empty-workspaces.lock"

if ! mkdir "$lock_dir" 2>/dev/null; then
  exit 0
fi

trap 'rmdir "$lock_dir"' EXIT INT TERM

while true; do
  active_workspace="$(hyprctl activeworkspace -j 2>/dev/null || printf '{}')"
  workspace_id="$(printf '%s' "$active_workspace" | jq -r '.id // 0')"
  window_count="$(printf '%s' "$active_workspace" | jq -r '.windows // 0')"

  if [ "$workspace_id" -gt 5 ] 2>/dev/null && [ "$window_count" -eq 0 ] 2>/dev/null; then
    hyprctl dispatch workspace 5 >/dev/null 2>&1
  fi

  sleep 0.5
done
