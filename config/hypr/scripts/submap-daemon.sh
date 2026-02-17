#!/usr/bin/env bash
set -euo pipefail

sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
sock="${XDG_RUNTIME_DIR}/hypr/${sig}/.socket2.sock"
state="${XDG_RUNTIME_DIR}/hypr-submap-state"
log="${XDG_RUNTIME_DIR}/hypr-submap-daemon.log"

if [ -z "$sig" ] || [ ! -S "$sock" ]; then
  printf '[daemon] socket missing: %s\n' "$sock" >>"$log"
  exit 1
fi

echo "reset" >"$state"
printf '[daemon] listening on %s\n' "$sock" >>"$log"

socat -u "UNIX-CONNECT:${sock}" - 2>>"$log" |
while IFS= read -r line; do
  if [[ "$line" == submap\>\>* ]]; then
    mode="${line#submap>>}"
    [ -z "$mode" ] && mode="reset"
    printf '%s\n' "$mode" >"$state"
    printf '[daemon] event: %s -> %s\n' "$line" "$mode" >>"$log"
  fi
done
