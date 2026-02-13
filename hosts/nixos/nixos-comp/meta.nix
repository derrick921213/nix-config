{
  self,
  inputs,
  ...
}: {
  system = "aarch64-linux";
  user = "derrick";
  hostip = "172.16.125.143";
  remoteBuild = true;
  diskDevice = "/dev/nvme0n1";
  extraModules = [
    (self + "/modules/firewall.nix")
    (self + "/modules/desktop/greetd.nix")
    (self + "/modules/desktop/hyprland.nix")
    (self + "/modules/desktop/qtile.nix")
    ../dolphin.nix
    inputs.disko.nixosModules.disko
    inputs.nix-ld.nixosModules.nix-ld
    ./disko.nix
  ];
  firewall-tags = ["ssh" "web"];
  pkgsChannel = "stable";
  deployment = {
    targetHost = "172.16.125.143";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
