{pkgs, ...}: {
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  environment.systemPackages = with pkgs;
  with kdePackages; [
    qtsvg
    kio
    dolphin
    dolphin-plugins
    baloo-widgets
    baloo
    kio-fuse
    kio-extras
    kio-admin
    kde-cli-tools
    kcmutils
    plasma-desktop
    samba
    kservice
    cifs-utils
    glib
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
  services.samba.openFirewall = true;
  networking.firewall.allowedUDPPorts = [5353];
}
