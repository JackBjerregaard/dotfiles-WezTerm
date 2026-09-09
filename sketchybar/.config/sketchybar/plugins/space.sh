#!/usr/bin/env bash

# Compatibility wrapper for manual calls. Normal workspace updates are driven
# by plugins/spaces.sh from the always-visible spacer.1 item.
exec "$HOME/.config/sketchybar/plugins/spaces.sh"
