{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  boot.plymouth = {
    enable = true;
    # 你可以選擇主題，例如 "breeze", "fade-in", "glow" 等
    theme = "bgrt";
  };
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.route_localnet" = 1;
    "net.ipv4.conf.lo.route_localnet" = 1;
  };
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["btrfs"];
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.initrd.kernelModules = ["i915"];
  boot.kernelParams = [
    # "snd_hda_intel.model=headset-mode"
    # "snd_hda_intel.model=dell-headset-multi"
    "snd_hda_intel.power_save=0"
    "snd_hda_intel.power_save_controller=N"
    # "snd_hda_intel.model=alc255-acer"
    "snd_hda_intel.model=inv-jack-detect"
    # "snd_hda_intel.model=alc897-desktop"
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkIf isX86_64 true;
  };
  networking.networkmanager.plugins = with pkgs; [networkmanager-openvpn];
  programs.openvpn3.enable = true;
  environment.systemPackages =
    (with pkgs; [
      vim
      wget
      brightnessctl
      pavucontrol
      pasystray
      pamixer
      stirling-pdf
      affine
      xournalpp
      kdePackages.okular
      kdePackages.gwenview
      kdePackages.kwave
      kdePackages.k3b
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.kwalletmanager
      kdePackages.kdialog
      nomacs
      vlc
      audacity
      dust
      ncdu
      atool
      qbittorrent-enhanced
      rclone
      rclone-ui
      rclone-browser
      bleachbit
      hardinfo2
      localsend
      clamav
      clamtk
      networkmanagerapplet
      file
      xdg-utils
      shared-mime-info
      kdePackages.polkit-kde-agent-1
      libsecret
      dig
      yazi
      broot
      sshfs
      filezilla
      bruno
      glow
      lsof
      pv
      gobang
      sqlitebrowser
      cloudflare-warp
      alsa-utils
      winboat
      freerdp
      openvpn
      networkmanager-openvpn
      unzip
    ])
    ++ lib.optionals isX86_64 (with pkgs; [
      lutris
      mold-wrapped
    ]);
  services.cloudflare-warp.enable = true;
  services.flatpak.enable = true;
  services.udev.packages = [pkgs.brightnessctl pkgs.networkmanagerapplet];
  programs.seahorse.enable = true;
  environment.variables = {
    GASKPASS = "${pkgs.kdePackages.kdialog}/bin/kdialog";
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  security.pki.certificateFiles = [
    ./AD_RootCA.pem
  ];
  # programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    # 如果還是報錯，可以再補這兩個
    libgcc
    glibc
  ];
}
