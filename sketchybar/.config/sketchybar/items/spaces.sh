#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

sketchybar --add item spacer.1 left \
	--set spacer.1 background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	width=10

for i in {1..10}; do
	sketchybar --add space space.$i left \
		--set space.$i \
		associated_space=$i \
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
		click_script="yabai -m space --focus $i 2>/dev/null" \
		script="$PLUGIN_DIR/space.sh" \
		--subscribe space.$i space_change space_windows_change
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
