{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "192.168.1.4" = {
        hostname = "192.168.1.4";
        user = "derrick";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "github.com-out" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_out";
        identitiesOnly = true;
      };
    };
  };
}
