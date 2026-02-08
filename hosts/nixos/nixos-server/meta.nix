{self, ...}: {
  system = "aarch64-linux";
  user = "derrick";
  hostip = "172.16.125.139";
  remoteBuild = true;
  extraModules = [(import (self + "/hosts/common/firewall.nix"))];
  firewall-tags = ["ssh" "web"];
  deployment = {
    targetHost = "172.16.125.139";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
