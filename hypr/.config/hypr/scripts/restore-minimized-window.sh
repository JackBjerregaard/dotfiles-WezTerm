#!/usr/bin/env sh

[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || exit 0

target_workspace="$(
  hyprctl monitors -j 2>/dev/null \
    | jq -r 'map(select(.focused))[0].activeWorkspace.id // empty | select(. > 0)'
)"

[ -n "$target_workspace" ] || target_workspace="$(
  hyprctl activeworkspace -j 2>/dev/null \
    | jq -r '.id // empty | select(. > 0)'
)"

[ -n "$target_workspace" ] || exit 1

active_window="$(hyprctl activewindow -j 2>/dev/null || printf '{}')"
active_address="$(printf '%s' "$active_window" | jq -r '.address // empty')"
active_workspace="$(printf '%s' "$active_window" | jq -r '.workspace.name // empty')"

# If focused window is already in the minimized workspace, restore it directly
if [ "$active_workspace" = "special:minimized" ] && [ -n "$active_address" ]; then
  hyprctl --batch "dispatch movetoworkspacesilent $target_workspace,address:$active_address; dispatch togglespecialworkspace minimized; dispatch workspace $target_workspace; dispatch focuswindow address:$active_address" >/dev/null
  exit 0
fi

# Otherwise restore the last window from the minimized workspace
restore_address="$(
  hyprctl clients -j 2>/dev/null \
    | jq -r '[.[] | select(.workspace.name == "special:minimized")] | last | .address // empty'
)"

[ -n "$restore_address" ] || exit 1

hyprctl --batch "dispatch movetoworkspacesilent $target_workspace,address:$restore_address; dispatch workspace $target_workspace; dispatch focuswindow address:$restore_address" >/dev/null
