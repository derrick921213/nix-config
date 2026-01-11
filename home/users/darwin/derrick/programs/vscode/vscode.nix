{
  pkgs,
  lib,
  ...
}: let
  common = import ./common.nix {inherit pkgs lib;};
in {
  programs.vscode = {
    enable = true;
    profiles =
      (import ./profiles/default.nix)
      // (import ./profiles/python.nix)
      // (import ./profiles/rust.nix)
      // (import ./profiles/nix.nix);
  };
}
