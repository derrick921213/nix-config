{
  pkgs,
  inputs,
  self,
  user,
  ...
}: {
  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@admin" "derrick"];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    channel.enable = false;
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
      inherit inputs self;
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
