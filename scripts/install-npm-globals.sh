#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_file="${repo_root}/npm-global-packages.txt"
npm_prefix="${NPM_CONFIG_PREFIX:-$HOME/.npm-global}"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is not installed. Install Node.js/npm first, then rerun this script." >&2
  exit 1
fi

if [[ ! -f "$package_file" ]]; then
  echo "Missing package list: $package_file" >&2
  exit 1
fi

mapfile -t packages < <(
  sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$package_file"
)

if (( ${#packages[@]} == 0 )); then
  echo "No npm global packages listed in $package_file."
  exit 0
fi

mkdir -p "$npm_prefix"
npm config set prefix "$npm_prefix" >/dev/null
npm install -g "${packages[@]}"
