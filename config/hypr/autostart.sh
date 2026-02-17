# #!/usr/bin/env bash

# pkill waybar
# pkill hyprpaper
# pkill fcitx5
# pkill nm-applet

# sleep 0.2

# waybar &
# hyprpaper &
# fcitx5 -d &
# nm-applet --indicator &
# pgrep -f submap-daemon.sh || ~/.config/hypr/scripts/submap-daemon.sh &

# vmware-user-suid-wrapper &

# # mako &  (通知守護行程)

#!/usr/bin/env bash
set -euo pipefail

log() { printf '[autostart] %s\n' "$*" >&2; }

# 以「指令片段」做判斷，避免誤殺別的同名程式
ensure_running() {
  local match="$1"
  shift
  if pgrep -af -- "$match" >/dev/null; then
    log "already running: $match"
  else
    log "starting: $*"
    "$@" &
  fi
}

# 有些程式需要重啟（如 waybar/hyprpaper）可以用 restart
restart() {
  local match="$1"
  shift
  if pgrep -af -- "$match" >/dev/null; then
    log "restarting: $match"
    pkill -f -- "$match" || true
    # 等一下讓它確實結束
    for _ in {1..20}; do
      pgrep -af -- "$match" >/dev/null || break
      sleep 0.05
    done
  fi
  log "starting: $*"
  "$@" &
}

# --- 你想「每次 reload 都重啟」的：restart ---
restart "^waybar$" waybar
restart "^hyprpaper$" hyprpaper

# fcitx5 建議不要每次都砍掉重啟，讓它常駐更穩
ensure_running "^fcitx5" fcitx5 -d

# nm-applet 你原本用 --indicator，建議防重複即可
ensure_running "nm-applet --indicator" nm-applet --indicator

# submap daemon：本來就該常駐，防重複即可
ensure_running "submap-daemon\.sh" "$HOME/.config/hypr/scripts/submap-daemon.sh"

# VMware tools：防重複
ensure_running "vmware-user-suid-wrapper" vmware-user-suid-wrapper