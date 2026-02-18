#!/usr/bin/env bash
set -euo pipefail
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
log() { printf '[autostart] %s\n' "$*" >&2; }

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

restart() {
  local match="$1"
  shift
  if pgrep -af -- "$match" >/dev/null; then
    log "restarting: $match"
    pkill -f -- "$match" || true
    for _ in {1..20}; do
      pgrep -af -- "$match" >/dev/null || break
      sleep 0.05
    done
  fi
  log "starting: $*"
  "$@" &
}

restart "^waybar$" waybar
restart "^hyprpaper$" hyprpaper
restart "submap-daemon\.sh" "$HOME/.config/hypr/scripts/submap-daemon.sh"

ensure_running "^fcitx5" fcitx5 -d

ensure_running "nm-applet --indicator" nm-applet --indicator

#ensure_running "submap-daemon\.sh" "$HOME/.config/hypr/scripts/submap-daemon.sh"

# if ! systemctl --user is-active --quiet hyprpolkitagent; then
#     log "starting hyprpolkitagent via systemd"
#     systemctl --user start hyprpolkitagent
# fi

ensure_running "vmware-user-suid-wrapper" vmware-user-suid-wrapper
ensure_running "snappy-switcher --daemon" snappy-switcher --daemon
systemctl --user start hyprpolkitagent
sleep 1
ensure_running "kwalletd6" kwalletd6
ensure_running "^hypridle$" hypridle
ensure_running "^udiskie$" udiskie
ensure_running "^mako$" mako
ensure_running "^blueman-applet$" blueman-applet
ensure_running "^pasystray$" pasystray
ensure_running "hyprlock-lock-listener" bash -lc '
  set -euo pipefail
  exec -a hyprlock-lock-listener bash -lc "
    dbus-monitor --system \"type=signal,interface=org.freedesktop.login1.Session,member=Lock\" |
    while read -r line; do
      case \"\$line\" in
        *\"member=Lock\"*)
          pgrep -x hyprlock >/dev/null 2>&1 || hyprlock &
          ;;
      esac
    done
  "
'
