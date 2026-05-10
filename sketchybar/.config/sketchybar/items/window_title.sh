#!/usr/bin/env bash

sketchybar --add item window_title left \
	--set window_title \
	drawing=off \
	icon.drawing=off \
	label.color="$COMMENT" \
	label.font="$FONT:Regular:12.0" \
	script="$PLUGIN_DIR/window_title.sh" \
	--subscribe window_title front_app_switched window_focus
