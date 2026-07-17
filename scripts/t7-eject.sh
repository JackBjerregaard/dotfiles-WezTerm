#!/usr/bin/env bash
set -euo pipefail

name_or_path="${1:-T7}"

usage() {
  cat <<'EOF'
Usage: t7-eject [volume-name-or-mountpoint]

Find processes using an external disk, ask before closing them, then eject it.
Defaults to volume name: T7

macOS examples:
  t7-eject
  t7-eject T7
  t7-eject /Volumes/T7

Linux examples:
  t7-eject T7
  t7-eject /run/media/$USER/T7
EOF
}

if [[ "${name_or_path}" == "-h" || "${name_or_path}" == "--help" ]]; then
  usage
  exit 0
fi

confirm() {
  local prompt="$1"
  local answer
  read -r -p "$prompt [y/N] " answer
  [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]
}

die() {
  echo "error: $*" >&2
  exit 1
}

detect_platform() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unsupported" ;;
  esac
}

resolve_macos_mountpoint() {
  local value="$1"
  if [[ "$value" == /* ]]; then
    printf '%s\n' "$value"
  else
    printf '/Volumes/%s\n' "$value"
  fi
}

resolve_linux_mountpoint() {
  local value="$1"
  local mountpoint=""

  if [[ "$value" == /* ]]; then
    printf '%s\n' "$value"
    return
  fi

  if command -v findmnt >/dev/null 2>&1; then
    mountpoint="$(findmnt -rn -S "LABEL=$value" -o TARGET 2>/dev/null | head -n 1 || true)"
  fi

  if [[ -z "$mountpoint" && -d "/run/media/$USER/$value" ]]; then
    mountpoint="/run/media/$USER/$value"
  elif [[ -z "$mountpoint" && -d "/media/$USER/$value" ]]; then
    mountpoint="/media/$USER/$value"
  elif [[ -z "$mountpoint" && -d "/mnt/$value" ]]; then
    mountpoint="/mnt/$value"
  elif [[ -z "$mountpoint" ]]; then
    local lowercase
    lowercase="$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')"
    if [[ -d "/mnt/$lowercase" ]]; then
      mountpoint="/mnt/$lowercase"
    fi
  fi

  printf '%s\n' "$mountpoint"
}

list_lsof() {
  local mountpoint="$1"
  lsof -nP +D "$mountpoint" 2>/dev/null || true
}

print_processes() {
  local lsof_output="$1"
  awk '
    NR == 1 { next }
    !seen[$2]++ {
      printf "  pid=%-8s user=%-12s command=%s\n", $2, $3, $1
    }
  ' <<<"$lsof_output"
}

pids_from_lsof() {
  awk 'NR > 1 { print $2 }' | sort -u
}

kill_processes() {
  local pids=("$@")
  local still_running=()

  if (( ${#pids[@]} == 0 )); then
    return
  fi

  echo "Sending TERM to: ${pids[*]}"
  kill -TERM "${pids[@]}" 2>/dev/null || true
  sleep 2

  for pid in "${pids[@]}"; do
    if kill -0 "$pid" 2>/dev/null; then
      still_running+=("$pid")
    fi
  done

  if (( ${#still_running[@]} > 0 )); then
    echo "Still running after TERM: ${still_running[*]}"
    echo "Sending KILL to remaining processes."
    kill -KILL "${still_running[@]}" 2>/dev/null || true
    sleep 1
  fi
}

eject_macos() {
  local mountpoint="$1"
  diskutil eject "$mountpoint"
}

eject_linux() {
  local mountpoint="$1"
  local source=""
  local parent=""

  sync

  if command -v findmnt >/dev/null 2>&1; then
    source="$(findmnt -rn -T "$mountpoint" -o SOURCE 2>/dev/null | head -n 1 || true)"
  fi

  if [[ -n "$source" && -b "$source" && "$(command -v udisksctl || true)" ]]; then
    udisksctl unmount -b "$source"
    if command -v lsblk >/dev/null 2>&1; then
      parent="$(lsblk -no PKNAME "$source" 2>/dev/null | head -n 1 | tr -d ' ' || true)"
    fi
    if [[ -n "$parent" && -b "/dev/$parent" ]]; then
      udisksctl power-off -b "/dev/$parent" || true
    fi
    return
  fi

  umount "$mountpoint"
}

main() {
  local platform
  local mountpoint
  local lsof_output
  local pids=()

  platform="$(detect_platform)"

  case "$platform" in
    macos)
      mountpoint="$(resolve_macos_mountpoint "$name_or_path")"
      ;;
    linux)
      mountpoint="$(resolve_linux_mountpoint "$name_or_path")"
      ;;
    wsl)
      die "WSL cannot reliably eject native Windows USB disks. Use scripts/t7-eject.ps1 from PowerShell instead."
      ;;
    *)
      die "unsupported platform: $(uname -s)"
      ;;
  esac

  [[ -n "$mountpoint" ]] || die "could not find mountpoint for '$name_or_path'"
  [[ -d "$mountpoint" ]] || die "mountpoint does not exist: $mountpoint"
  command -v lsof >/dev/null 2>&1 || die "lsof is required"

  echo "Checking processes using: $mountpoint"
  lsof_output="$(list_lsof "$mountpoint")"

  if [[ -n "$lsof_output" ]]; then
    echo "Processes with open files on this disk:"
    print_processes "$lsof_output"
    while IFS= read -r pid; do
      pids+=("$pid")
    done < <(pids_from_lsof <<<"$lsof_output")

    if confirm "Force close these processes and eject '$mountpoint'?"; then
      kill_processes "${pids[@]}"
    else
      echo "Not closing processes or ejecting."
      exit 1
    fi
  else
    echo "No open files found."
    if ! confirm "Eject '$mountpoint'?"; then
      echo "Not ejecting."
      exit 1
    fi
  fi

  echo "Ejecting: $mountpoint"
  case "$platform" in
    macos) eject_macos "$mountpoint" ;;
    linux) eject_linux "$mountpoint" ;;
  esac
}

main "$@"
