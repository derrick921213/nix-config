# {
#   pkgs,
#   lib,
#   ...
# }: let
#   common = import ./common.nix {inherit pkgs lib;};
#   profileFiles = lib.sort (a: b: a < b) (
#     builtins.filter (n: lib.hasSuffix ".nix" n)
#     (builtins.attrNames (builtins.readDir ./profiles))
#   );
#   importProfile = file:
#     import (./profiles + "/${file}") {inherit pkgs common;};
#   profiles =
#     builtins.foldl'
#     (acc: file: acc // importProfile file)
#     {}
#     profileFiles;
# in {
#   programs.vscode = {
#     enable = true;
#     inherit profiles;
#     mutableExtensionsDir = true;
#   };
# }
{
  pkgs,
  lib,
  ...
}: let
  common = import ./common.nix {inherit pkgs lib;};
in {
  programs.vscode = {
    enable = true;
    extensions = common.commonExtensions;
    userSettings = common.commonUserSettings;
    mutableExtensionsDir = true;
  };
}
