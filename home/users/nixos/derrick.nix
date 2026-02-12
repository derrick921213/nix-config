{...}: let
in {
  imports = [../core.nix ../../profiles/hyprland.nix ../../profiles/qtile.nix];
  home.username = "derrick";
  home.homeDirectory = "/home/derrick";
  xdg.enable = true;
}
