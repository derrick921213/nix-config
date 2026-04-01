{pkgs, ...}: {
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
      domain = true;
    };
  };
  environment.systemPackages = [pkgs.uxplay];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  networking.firewall.allowedTCPPorts = [7000 7001 7100];
  networking.firewall.allowedUDPPorts = [5353 6000 6001 7011];
}
