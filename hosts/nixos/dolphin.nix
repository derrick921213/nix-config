{...}: {
  environment.systemPackages = with pkgs;
  with kdePackages; [
    qtsvg
    kio
    dolphin
    kio-fuse
    kio-extras
  ];
}
