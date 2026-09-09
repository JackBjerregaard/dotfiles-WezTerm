#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

# Workspace indicators, driven by AeroSpace.
#
# These used to be SketchyBar `space` items with `associated_space=$i`, which
# hooks SketchyBar's built-in macOS Spaces integration and its space_change /
# space_windows_change events. AeroSpace does not use macOS Spaces at all — its
# workspaces are its own construct — so those events never fire for it and the
# built-in item type cannot see the state.
#
# They are therefore plain items now, updated from the custom
# `aerospace_workspace_change` event that aerospace.toml raises via
# `exec-on-workspace-change`, plus window_focus / front_app_switched so the app
# icons refresh when windows open and close.
#
# Nine items, matching persistent-workspaces = 1..9 in aerospace.toml and the
# ctrl+1..9 / hyper+1..9 binds. The first five are always shown; 6..9 are
# hidden until focused or used.

sketchybar --add item spacer.1 left \
	--set spacer.1 background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	width=10 \
	script="$PLUGIN_DIR/spaces.sh" \
	--subscribe spacer.1 aerospace_workspace_change window_focus front_app_switched

for i in {1..9}; do
	drawing=on
	[ "$i" -gt 5 ] && drawing=off

	sketchybar --add item space.$i left \
		--set space.$i \
		drawing="$drawing" \
		icon=$i \
		icon.font="$FONT:Bold:13.0" \
		icon.padding_left=14 \
		icon.padding_right=8 \
		icon.color="$COMMENT" \
		label.font="sketchybar-app-font:Regular:16.0" \
		label.padding_right=14 \
		label.color="$COMMENT" \
		label.y_offset=-1 \
		background.color="$BAR_COLOR" \
		background.padding_left=2 \
		background.padding_right=2 \
		click_script="aerospace workspace $i"
done

sketchybar --add item spacer.2 left \
	--set spacer.2 background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	width=5

sketchybar --add bracket spaces '/space.*/' \
	--set spaces \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$RED" \
	background.corner_radius="$CORNER_RADIUS" \
	background.color="$BAR_COLOR" \
	background.height=26 \
	background.drawing=on
