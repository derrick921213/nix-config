{...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@admin"];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
  };
}
