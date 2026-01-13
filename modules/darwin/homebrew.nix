{
  config,
  inputs,
  user,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

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
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
