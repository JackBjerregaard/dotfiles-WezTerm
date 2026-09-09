#!/usr/bin/env bash
set -u

# Watch WindowServer for the event-tap spin documented in
# ~/Desktop/mac-freeze-and-yabai-notes.md.
#
# The failure signature: WindowServer's resident memory climbs well above its
# ~250 MB baseline while CPU spikes, because it is stuck delivering input events
# into a tap whose client stopped draining them. All input — cursor, keys,
# clicks — flows through that pipeline, so this shows up as an unmovable mouse
# and sluggish Spotlight before it becomes a full freeze.
#
# Usage:
#   ./watch-windowserver.sh            # sample every 30s, print only changes
#   ./watch-windowserver.sh 10         # sample every 10s
#   ./watch-windowserver.sh 30 ~/ws.log  # also append to a log file
#
# Reference points from the 2026-08-29 episode:
#   healthy   ~250 MB,  <10% cpu
#   degraded  >600 MB   (input lag noticeable)
#   critical  >950 MB   (a jetsam fired at 969 MB on 2026-08-18)

interval="${1:-30}"
logfile="${2:-}"

pid="$(pgrep -x WindowServer | head -1)"
if [ -z "$pid" ]; then
  echo "could not find WindowServer" >&2
  exit 1
fi

emit() {
  local line="$1"
  echo "$line"
  [ -n "$logfile" ] && echo "$line" >> "$logfile"
}

emit "# watching WindowServer pid=$pid every ${interval}s — $(date '+%Y-%m-%d %H:%M:%S')"
emit "# baseline ~250MB. warn >600MB. critical >950MB."

last_state=""
while true; do
  read -r cpu rss <<<"$(ps -o pcpu=,rss= -p "$pid" 2>/dev/null)"
  [ -z "${rss:-}" ] && { emit "$(date '+%H:%M:%S')  WindowServer gone (pid $pid) — it restarted or the session ended"; exit 1; }

  mb=$(( rss / 1024 ))
  if   [ "$mb" -gt 950 ]; then state="CRITICAL"
  elif [ "$mb" -gt 600 ]; then state="WARN"
  else                        state="ok"
  fi

  # Print every sample when not ok, otherwise only on a state change, so a
  # healthy machine stays quiet and a degrading one is verbose.
  if [ "$state" != "ok" ] || [ "$state" != "$last_state" ]; then
    emit "$(date '+%H:%M:%S')  cpu=${cpu}%  rss=${mb}MB  [$state]"
  fi
  last_state="$state"

  sleep "$interval"
done
