{
  config,
  lib,
  hostMeta,
  ...
}: let
  tags = hostMeta.firewall-tags or [];
  hasTag = tag: builtins.elem tag tags;
in {
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["docker0"];
    allowedTCPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "web") [80 443])
      (lib.mkIf (hasTag "minecraft") [25565])
      (lib.mkIf (hasTag "ssh") [22])
      (lib.mkIf (hasTag "maygod") [8373])
      (lib.mkIf (hasTag "npm") [81])
    ];
    checkReversePath = "loose";
    # 根據標籤自動開啟 UDP 埠口
    allowedUDPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "dns") [53])
    ];
  };
}
