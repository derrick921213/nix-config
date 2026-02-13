{self, ...}: {
  system = "aarch64-linux";
  user = "derrick";
  hostip = "172.16.125.142";
  remoteBuild = true;
  extraModules = [(import (self + "/modules/filewall/firewall.nix"))];
  firewall-tags = ["ssh" "web"];
  pkgsChannel = "stable";
}
