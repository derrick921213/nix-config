{user, ...}: {
  system = {
    stateVersion = 6;
    primaryUser = user;
  };
  nix.enable = true;
  programs.zsh.enable = true;
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
