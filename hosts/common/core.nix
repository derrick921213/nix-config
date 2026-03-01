{
  pkgs,
  inputs,
  self,
  user,
  hostname,
  ...
}: {
  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@admin" "derrick"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    channel.enable = true;
  };

  networking.hostName = hostname;

  users.users.${user} =
    {
      home =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${user}"
        else "/home/${user}";
      shell = pkgs.zsh;
    }
    // (pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    });

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    just
    git
    curl
    wget
    vim
    neovim
    htop
    tmux
    tree
    ripgrep
    fd
    jq
    alejandra
    neofetch
    mkcert
  ];
  programs = {
    zsh.enable = true;
    nix-index.enable = true;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs self user;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    };
    backupFileExtension = "backup";
    users.${user} = {
      imports = let
        isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
        platformDir =
          if isDarwin
          then "darwin"
          else "nixos";
      in [
        (import (self + "/home/users/${platformDir}/${user}.nix"))
      ];
    };
  };
}
