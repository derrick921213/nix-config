{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellApplication
      {
        name = "ns";
        runtimeInputs = [pkgs.nix-search-tv pkgs.fzf];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
  ];
}
