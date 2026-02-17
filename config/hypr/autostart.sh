#!/usr/bin/env bash

pkill waybar
pkill hyprpaper
pkill fcitx5
pkill nm-applet

sleep 0.2

waybar &
hyprpaper &
fcitx5 -d &
nm-applet --indicator &

vmware-user-suid-wrapper &

# mako &  (通知守護行程)