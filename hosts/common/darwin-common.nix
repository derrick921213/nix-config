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
    ./core.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  system = {
    stateVersion = 6;
    primaryUser = user;
  };

  nix.gc.interval = {
    Weekday = 0;
    Hour = 3;
    Minute = 0;
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

  environment.systemPackages = with pkgs; [
    iterm2
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
