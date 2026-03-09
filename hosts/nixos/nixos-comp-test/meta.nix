{
  self,
  inputs,
  ...
}: {
  system = "x86_64-linux";
  user = "derrick";
  hostip = "192.168.0.185";
  remoteBuild = true;
  diskDevice = "/dev/sda";
  extraModules = [
    (self + "/modules/filewall/firewall.nix")
    (self + "/modules/virtualisation/docker.nix")
    inputs.disko.nixosModules.disko
    inputs.nix-ld.nixosModules.nix-ld
    ./disko.nix
    ./hardware-configuration.nix
  ];
  firewall-tags = ["ssh" "web" "maygod"];
  pkgsChannel = "stable";
  deployment = {
    targetHost = "192.168.0.185";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
