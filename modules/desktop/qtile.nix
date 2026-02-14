{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.variables = {
    XCURSOR_SIZE = "24";
  };
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    videoDrivers = ["modesetting"];
    windowManager.qtile.enable = true;
    displayManager.startx.enable = true;
    desktopManager.runXdgAutostartIfNone = true;
  };
  #   services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    rofi
    picom
    maim
    xclip
    btop
    xev
    xorg.xrandr
    libnotify
  ];
}
