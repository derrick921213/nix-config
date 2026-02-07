{...}: let
in {
  imports = [../core.nix];
  home.username = "derrick";
  home.homeDirectory = "/home/derrick";
}
