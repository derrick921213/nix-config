{
  self,
  inputs,
  ...
}: {
  system = "x86_64-linux";
  user = "derrick";
  hostip = "172.16.125.144";
  remoteBuild = true;
  diskDevice = "/dev/sda";
  extraModules = [
    (self + "/modules/filewall/firewall.nix")
    (self + "/modules/desktop/greetd.nix")
    (self + "/modules/desktop/hyprland.nix")
    (self + "/modules/desktop/qtile.nix")
    (self + "/modules/filemanager/dolphin.nix")
    (self + "/modules/virtualisation/docker.nix")
    (self + "/modules/virtualisation/virt-qemu.nix")
    # inputs.disko.nixosModules.disko
    inputs.nix-ld.nixosModules.nix-ld
    # ./disko.nix
  ];
  firewall-tags = ["ssh" "web"];
  pkgsChannel = "stable";
  deployment = {
    targetHost = "172.16.125.144";
    targetUser = "derrick";
    targetPort = 22;
    buildOnTarget = true;
  };
}
