{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nix-config/config";
  create_symlink = name: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  targetConfigs = ["qtile"];
in {
  # xdg.configFile."qtile" = {
  #   source = builtins.path {
  #     path = ./../../config/qtile;
  #     name = "qtile-config";
  #   };
  #   recursive = true;
  # };
  xdg.configFile = pkgs.lib.genAttrs targetConfigs (name: {
    source = create_symlink name;
    recursive = false;
  });
}
