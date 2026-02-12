{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  #   services.xserver.displayManager.startx.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    rofi
    picom
    xorg.xrandr
  ];
}
