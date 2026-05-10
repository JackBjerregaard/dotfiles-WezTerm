#!/usr/bin/env bash

sketchybar --add item dnd right \
	--set dnd \
	update_freq=10 \
	drawing=off \
	label="Focus" \
	label.color="$RED" \
	label.padding_left=10 \
	label.padding_right=10 \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$RED" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/dnd.sh" \
	--subscribe dnd system_woke
