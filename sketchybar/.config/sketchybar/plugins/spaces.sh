#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
case "$FOCUSED" in
	''|*[!0-9]*) FOCUSED=1 ;;
esac

MAX_VISIBLE=5
if [ "$FOCUSED" -gt "$MAX_VISIBLE" ]; then
	MAX_VISIBLE="$FOCUSED"
fi

for i in {1..9}; do
	APPS="$(aerospace list-windows --workspace "$i" --format '%{app-name}' 2>/dev/null | sort -u)"

	if [ -n "$APPS" ] && [ "$i" -gt "$MAX_VISIBLE" ]; then
		MAX_VISIBLE="$i"
	fi
done

for i in {1..9}; do
	ICON_LINE=""
	while IFS= read -r APP; do
		[ -z "$APP" ] && continue
		__icon_map "$APP"
		ICON_LINE="$ICON_LINE $icon_result"
	done < <(aerospace list-windows --workspace "$i" --format '%{app-name}' 2>/dev/null | sort -u)

	DRAWING=off
	if [ "$i" -le "$MAX_VISIBLE" ]; then
		DRAWING=on
	fi

	if [ "$i" = "$FOCUSED" ]; then
		COLOR="$RED"
	else
		COLOR="$COMMENT"
	fi

	sketchybar --animate tanh 5 --set "space.$i" \
		drawing="$DRAWING" \
		icon.color="$COLOR" \
		label.color="$COLOR" \
		label="$ICON_LINE"
done
