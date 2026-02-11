{
  self,
  inputs,
  ...
}: {
  system = "aarch64-linux";
  user = "derrick";
  hostip = "172.16.125.139";
  remoteBuild = true;
  diskDevice = "/dev/nvme0n1";
  extraModules = [
    (self + "/hosts/common/firewall.nix")
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];
  firewall-tags = ["ssh" "web"];
  pkgsChannel = "stable";
  deployment = {
    targetHost = "172.16.125.139";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
