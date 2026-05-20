#!/usr/bin/env bash

COLOR="$BLUE"

sketchybar --add item wifi right \
	--set wifi \
	update_freq=30 \
	icon="󰤨" \
	icon.color="$COLOR" \
	icon.padding_left=8 \
	icon.padding_right=8 \
	label.drawing=off \
	background.height=26 \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_right=5 \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/wifi.sh" \
	--subscribe wifi wifi_change system_woke
