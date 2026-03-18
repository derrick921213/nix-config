{...}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "gitlab.com-out" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_out";
        identitiesOnly = true;
      };
    };
  };
}
