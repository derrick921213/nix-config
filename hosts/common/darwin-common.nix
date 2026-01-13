{
  config,
  inputs,
  user,
  pkgs,
  hostname,
  self,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  system = {
    stateVersion = 6;
    primaryUser = user;
  };

  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@admin"];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
    };
    channel.enable = false;
  };

  home-manager = {
    networking.hostName = hostname;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {inherit inputs;};
    home-manager.backupFileExtension = "backup";
    home-manager.users.${user} = {imports = [(import (self + "/home/users/darwin/${user}/default.nix"))];};
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    autoMigrate = true;
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global.autoUpdate = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [];
    casks = [];
    masApps = {};
  };

  programs = {
    zsh.enable = true;
    nix-index.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    iterm2
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

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock.autohide = false;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.swipescrolldirection" = false;
    };
  };
}
