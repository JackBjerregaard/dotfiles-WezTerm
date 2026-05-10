#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

case "$SENDER" in
  "space_change")
    if [ "$SELECTED" = "true" ]; then
      sketchybar --animate tanh 5 --set "$NAME" \
        icon.color="$RED" \
        label.color="$RED"
    else
      sketchybar --animate tanh 5 --set "$NAME" \
        icon.color="$COMMENT" \
        label.color="$COMMENT"
    fi
    ;;
  "space_windows_change")
    ITEM_SPACE="${NAME##*.}"
    CHANGED_SPACE=$(echo "$INFO" | jq -r '.space // empty')

    if [ "$ITEM_SPACE" = "$CHANGED_SPACE" ]; then
      ICON_LINE=""
      while IFS= read -r APP; do
        [ -z "$APP" ] && continue
        __icon_map "$APP"
        ICON_LINE="$ICON_LINE $icon_result"
      done < <(echo "$INFO" | jq -r '.apps | keys[]' 2>/dev/null)

      sketchybar --animate tanh 5 --set "$NAME" label="$ICON_LINE"
    fi
    ;;
esac
