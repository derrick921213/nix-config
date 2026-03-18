{
  config,
  pkgs,
  self,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nix-config/config";
  create_symlink = name: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
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

  xdg.configFile = pkgs.lib.genAttrs targetConfigs (name: {
    source = create_symlink name;
    recursive = false;
  });

  home.file."Pictures/wallpapers/cyberpunk.jpeg".source = self + "/wallpapers/cyberpunk.jpeg";
  home.shellAliases = {
    hyprlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
  };
}
