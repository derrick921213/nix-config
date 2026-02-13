{self, ...}: {
  system = "aarch64-linux";
  user = "derrick";
  hostip = "172.16.125.139";
  remoteBuild = true;
  extraModules = [(import (self + "/modules/filewall/firewall.nix"))];
  firewall-tags = ["ssh" "web"];
  pkgsChannel = "stable";
  deployment = {
    targetHost = "172.16.125.139";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
