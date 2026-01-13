{
  self,
  pkgs,
  ...
}: let
  auto = import (self + "/lib/auto-import.nix") {inherit self;};
in {
  imports =
    auto.importsFromDir ./.;
  # environment.systemPackages = with pkgs; [ ... ];
  homebrew.casks = [
    "hammerspoon"
    "firefox"
    "iina"
    "dropshelf"
  ];
}
