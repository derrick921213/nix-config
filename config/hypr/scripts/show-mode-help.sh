#!/usr/bin/env bash
set -euo pipefail

txt="$("$HOME/.config/hypr/scripts/mode-help.sh")"
state="${XDG_RUNTIME_DIR}/hypr-submap-state"
mode="$(cat "$state" 2>/dev/null || echo reset)"

[ -n "$txt" ] || exit 0

printf '%s\n' "$txt" \
  | rofi -dmenu -i -p "MODE: ${mode}" -no-custom -no-fixed-num-lines -lines 1
