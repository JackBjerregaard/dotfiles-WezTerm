#!/usr/bin/env bash

set -euo pipefail

command -v sensors >/dev/null 2>&1 || {
  printf '{"text":"","tooltip":"sensors not installed"}\n'
  exit 0
}

temp="$(
  sensors 2>/dev/null \
    | awk '
      /Package id 0:/ {
        gsub(/[+°C]/, "", $4)
        printf "%.0f", $4
        found = 1
        exit
      }
      /^Tctl:/ {
        gsub(/[+°C]/, "", $2)
        printf "%.0f", $2
        found = 1
        exit
      }
      END {
        if (!found) exit 1
      }
    '
)"

if [ -z "$temp" ]; then
  printf '{"text":"","tooltip":"No CPU temperature found"}\n'
  exit 0
fi

class=""
if [ "$temp" -ge 85 ]; then
  class='critical'
fi

printf '{"text":" %s°C","tooltip":"CPU package temperature","class":"%s"}\n' "$temp" "$class"
