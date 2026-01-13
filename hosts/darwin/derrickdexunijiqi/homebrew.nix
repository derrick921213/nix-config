{...}: {
  homebrew = {
    enable = true;
    casks = [
      "hammerspoon"
      "firefox"
      "iina"
      "dropshelf"
    ];
    onActivation.cleanup = "zap";
  };
}
