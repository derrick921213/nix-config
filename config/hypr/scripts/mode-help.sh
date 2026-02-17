#!/usr/bin/env bash
set -euo pipefail

state="${XDG_RUNTIME_DIR}/hypr-submap-state"
mode="$(cat "$state" 2>/dev/null || echo reset)"

case "$mode" in
  leader)
    echo "W:window  R:resize  M:move  S:shot  A:apps  P:power  ESC/Space:exit"
    ;;
  window)
    echo "HJKL:focus  Q:close  F:fullscreen  V:float  ESC:exit"
    ;;
  resize)
    echo "HJKL:resize  N:reflow  ESC:exit"
    ;;
  move)
    echo "HJKL:move window  ESC:exit"
    ;;
  screenshot)
    echo "S:area→clip  A:full→clip  F:area→file  P:full→file  ESC:exit"
    ;;
  power)
    echo "L:lock  R:reboot  P:poweroff  O:logout  ESC:exit"
    ;;
  reset|*)
    echo ""
    ;;
esac
