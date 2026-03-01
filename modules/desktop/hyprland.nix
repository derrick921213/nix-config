{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = ["hyprland" "gtk"];
    config.knetattach.default = ["kde"];
  };

  environment.systemPackages = with pkgs; [
    cliphist
    wl-clipboard
    grim
    slurp
    hyprpaper
    hyprlock
    hyprpolkitagent
    inputs.snappy-switcher.packages.${stdenv.hostPlatform.system}.default
  ];
}
