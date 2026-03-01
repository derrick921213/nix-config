{
  config,
  pkgs,
  self,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.config/nix-config/config";
  create_symlink = name: config.lib.mkOutOfStoreSymlink "${dotfiles}/${name}";
  targetConfigs = ["foot" "hypr" "waybar" "snappy-switcher"];
in {
  programs.foot.enable = true;
  programs.waybar.enable = true;
  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.udiskie.enable = true;
  services.mako.enable = true;
  services.hyprpolkitagent.enable = true;
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = "";
  };

  xdg.configFile = pkgs.lib.genAttrs targetConfigs (name: {
    source = create_symlink name;
    recursive = true;
  });

  # xdg.configFile."foot" = {
  #   source = create_symlink "foot";
  #   recursive = true;
  # };
  # xdg.configFile."hypr" = {
  #   source = create_symlink "hypr";
  #   recursive = true;
  # };
  # xdg.configFile."waybar" = {
  #   source = create_symlink "waybar";
  #   recursive = true;
  # };
  # xdg.configFile."snappy-switcher" = {
  #   source = create_symlink "snappy-switcher";
  #   recursive = true;
  # };
  home.file."Pictures/wallpapers/cyberpunk.jpeg".source = self + "/wallpapers/cyberpunk.jpeg";
  home.shellAliases = {
    hyprlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
  };
}
