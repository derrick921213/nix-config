{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  isX86_64 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["btrfs"];
  };

  boot.kernelParams = [
    # "snd_hda_intel.model=headset-mode"
    # "snd_hda_intel.model=dell-headset-multi"
    "snd_hda_intel.power_save=0"
    "snd_hda_intel.power_save_controller=N"
    # "snd_hda_intel.model=alc255-acer"
    "snd_hda_intel.model=inv-jack-detect"
    # "snd_hda_intel.model=alc897-desktop"
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkIf isX86_64 true;
  };
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
}
