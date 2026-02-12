{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."qtile" = {
    source = builtins.path {
      path = ./../../config/qtile;
      name = "qtile-config";
    };
    recursive = true;
  };
}
