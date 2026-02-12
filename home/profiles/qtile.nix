{
  config,
  pkgs,
  ...
}: {
  # xdg.configFile."qtile" = {
  #   source = self + /config/qtile;
  #   recursive = true;
  # };
  xdg.configFile."qtile" = {
    source = builtins.path {
      path = ./../../config/qtile;
      name = "qtile-config";
    };
    recursive = true;
  };
}
