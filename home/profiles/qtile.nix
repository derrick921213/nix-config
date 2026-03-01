{
  config,
  pkgs,
  ...
}: {
  # xdg.configFile."qtile" = {
  #   source = builtins.path {
  #     path = ./../../config/qtile;
  #     name = "qtile-config";
  #   };
  #   recursive = true;
  # };
  xdg.configFile."qtile" = {
    source = config.lib.mkOutOfStoreSymlink "/home/derrick/.config/nix-config/config/qtile";
    recursive = true;
  };
}
