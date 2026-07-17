#!/usr/bin/env bash

set -euo pipefail

# Creating spaces needs yabai's scripting addition, which needs SIP partially
# disabled. With SIP on this cannot create anything, so it only verifies the
# count and warns. Spaces are expected to be created once by hand in Mission
# Control; see README.
minimum="${1:-${YABAI_MIN_SPACES:-9}}"
created_space=false

if ! [[ "$minimum" =~ ^[0-9]+$ ]] || [ "$minimum" -lt 1 ]; then
  echo "usage: $0 [minimum-space-count]" >&2
  exit 2
fi

space_count() {
  yabai -m query --spaces | jq 'length'
}

while [ "$(space_count)" -lt "$minimum" ]; do
  if ! yabai -m space --create 2>/dev/null; then
    echo "yabai-ensure-min-spaces: only $(space_count)/$minimum spaces exist and" \
      "--create needs the scripting addition; add the rest via Mission Control" >&2
    break
  fi
  created_space=true
done

if [ "$created_space" = true ] && command -v sketchybar >/dev/null; then
  sketchybar --reload
fi
