{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    videoDrivers = ["modesetting"];
    windowManager.qtile.enable = true;
    displayManager.startx.enable = true;
  };
  #   services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    rofi
    picom
    xorg.xrandr
  ];
}
