{
  config,
  pkgs,
  ...
}: {
  #   xdg.configFile."qtile" = {
  # source = config.lib.file.mkOutOfStoreSymlink "../../config/qtile";
  # recursive = true;
  #   };
  xdg.configFile."qtile/config.py".source = ../../config/qtile/config.py;
}
