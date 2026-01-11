{
  pkgs,
  lib,
  ...
}: let
  common = import ./common.nix {inherit pkgs lib;};
  profileFiles = builtins.attrNames (builtins.readDir ./profiles);
  importProfile = file: import (./profiles + "/${file}");
  profiles =
    builtins.foldl'
    (acc: file: acc // importProfile file)
    {}
    profileFiles;
in {
  programs.vscode = {
    enable = true;
    inherit profiles;
  };
}
