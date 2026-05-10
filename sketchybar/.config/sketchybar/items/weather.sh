#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item weather right \
	--set weather \
	update_freq=1800 \
	icon.drawing=off \
	label.color="$COLOR" \
	label.padding_left=10 \
	label.padding_right=10 \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/weather.sh"
