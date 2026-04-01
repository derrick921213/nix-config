{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.uxplay
    (makeDesktopItem {
      name = "uxplay-custom";
      desktopName = "iOS Mirror";
      exec = "uxplay -p -n \"Derrick-NixOS\"";
      icon = "~/.config/icon/Airplay.png";
      terminal = false;
      categories = ["Utility"];
    })
  ];
  networking.firewall.allowedTCPPorts = [7000 7001 7100];
  networking.firewall.allowedUDPPorts = [5353 6000 6001 7011];
}
