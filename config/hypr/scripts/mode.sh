#!/usr/bin/env bash
set -euo pipefail

state="${XDG_RUNTIME_DIR}/hypr-submap-state"
mode="$(cat "$state" 2>/dev/null || echo reset)"

if [ "$mode" = "reset" ] || [ -z "$mode" ]; then
  echo "NORMAL"
else
  echo "${mode^^}"
fi
