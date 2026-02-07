{
  config,
  lib,
  self,
  ...
}: let
in {
  home.stateVersion = "25.11";
  imports = [
    (self + "/home/programs")
  ];
}
