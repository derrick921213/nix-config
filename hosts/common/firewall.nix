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
    allowedTCPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "web") [80 443])
      (lib.mkIf (hasTag "minecraft") [25565])
      (lib.mkIf (hasTag "ssh") [22])
    ];

    # 根據標籤自動開啟 UDP 埠口
    allowedUDPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "dns") [53])
    ];
  };
}
