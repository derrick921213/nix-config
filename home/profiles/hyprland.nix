{
  config,
  pkgs,
  ...
}: {
  programs.foot.enable = true;
  programs.waybar.enable = true;
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."foot" = {
    source = builtins.path {
      path = ./../../config/foot;
      name = "foot-config";
    };
    recursive = true;
  };
  xdg.configFile."hypr" = {
    source = builtins.path {
      path = ./../../config/hypr;
      name = "hyprland-config";
    };
    recursive = true;
  };
  xdg.configFile."waybar" = {
    source = builtins.path {
      path = ./../../config/waybar;
      name = "waybar-config";
    };
    recursive = true;
  };
  home.shellAliases = {
    hyprlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
  };
}
