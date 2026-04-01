{pkgs, ...}: {
  environment.systemPackages = [pkgs.uxplay];
  networking.firewall.allowedTCPPorts = [7000 7001 7100];
  networking.firewall.allowedUDPPorts = [5353 6000 6001 7011];
}
