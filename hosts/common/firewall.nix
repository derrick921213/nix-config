{
  config,
  lib,
  hostMeta,
  ...
}: let
  tags = hostMeta.tags or [];
  hasTag = tag: builtins.elem tag tags;
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "web") [80 443])
      (lib.mkIf (hasTag "squid-ordering") [8000 8080])
      (lib.mkIf (hasTag "ddns") [53 8081])
      (lib.mkIf (hasTag "minecraft") [25565])
    ];

    # 根據標籤自動開啟 UDP 埠口
    allowedUDPPorts = lib.mkMerge [
      (lib.mkIf (hasTag "dns") [53])
      (lib.mkIf (hasTag "wireguard") [51820])
    ];
  };
}
