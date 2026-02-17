#!/usr/bin/env bash
set -euo pipefail

sock="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
state="${XDG_RUNTIME_DIR}/hypr-submap-state"

echo "reset" > "$state"

exec socat -u "UNIX-CONNECT:${sock}" - \
  | awk -F'>>' '/^submap>>/ {print $2}' \
  | while IFS= read -r mode; do
      [ -n "$mode" ] && printf '%s\n' "$mode" > "$state"
    done
