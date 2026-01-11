{
  config,
  lib,
  ...
}: let
in {
  home.stateVersion = "25.11";
  imports = [./programs];
  home.activation.fixNixProfile = lib.hm.dag.entryAfter ["writeBoundary"] ''
    target="/etc/profiles/per-user/${config.home.username}"
    link="$HOME/.nix-profile"
    if [ -L "$link" ]; then
      cur="$(readlink "$link" || true)"
      if [ "$cur" != "$target" ]; then
        rm -f "$link"
      fi
    elif [ -e "$link" ]; then
      rm -rf "$link"
    fi
    ln -sfn "$target" "$link"
  '';
}
