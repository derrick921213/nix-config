{
  config,
  pkgs,
  lib,
  ...
}: let
  dropshelf = pkgs.callPackage ./dropshelf-package.nix {};
in {
  home.packages = [dropshelf];

  home.activation.linkDropshelf = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/Applications"
    ln -sf ${dropshelf}/Applications/*.app "$HOME/Applications/"
  '';
}
