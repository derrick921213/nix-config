{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    wofi
    wl-clipboard
    grim
    slurp
    hyprpaper
  ];
}
