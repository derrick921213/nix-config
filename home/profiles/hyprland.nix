{
  config,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=12";
      };
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$c" = "CONTROL";
      "exec-once" = [
        "waybar"
      ];
      bind = [
        "$mod, RETURN, exec, foot"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod $c, Q, exit"
      ];

      debug = {
        disable_logs = false;
      };
      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
      ];
    };
  };

  programs.waybar.enable = true;
  home.shellAliases = {
    hyprlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
  };
}
