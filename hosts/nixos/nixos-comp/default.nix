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

  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkIf isX86_64 true;
  };

  fileSystems."/".options = ["compress=zstd" "noatime"];
  fileSystems."/home".options = ["compress=zstd" "noatime"];
  fileSystems."/nix".options = ["compress=zstd" "noatime"];
  # fileSystems."/mnt/mac_derrick" = {
  #   device = "//172.16.125.1/derrick";
  #   fsType = "cifs";
  #   options = [
  #     "credentials=/etc/nixos/smb-secrets"
  #     "uid=1000"
  #     "gid=100"
  #     "file_mode=0664"
  #     "dir_mode=0775"
  #     "x-systemd.automount"
  #     "noauto"
  #     "x-systemd.idle-timeout=60"
  #   ];
  # };

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Taipei";

  i18n.defaultLocale = "zh_TW.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "zh_TW.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "zh_TW.UTF-8";
    LC_TIME = "zh_TW.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    vista-fonts
    corefonts
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  security.pam.services.greetd.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };

  users.users.derrick = {
    isNormalUser = true;
    description = "derrick";
    extraGroups = ["networkmanager" "wheel" "video" "audio"];
    hashedPassword = "$6$imjFfK.gjd3R5Tb3$0qqFQPLqUZ9oFP38736p3Q.VZz9c0w1Uepdbf6.ulXhWJx1gcgO6zL0pYQqlCHmjPYTflm3wIT4eTswkvjNxf1";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq3fqTChvwq6LS6MgIhUHtIAeTIt8NYtWLWeFM4fv0uqHBR8RGBpQICxUmhfuW4cIX3DfCTSlrmgStjQKJUGfR9LHHAJZfRc7eKlWDmj4h6Pfez+cv+dZp7i6FW4PbbKa5u0DnZqoUcjqsPBAW/xnNrKuFso2GBQDVL/ynvvwp/8o+wHUR5f4n6Gshy2uFTx35gtEXLMd/BA+I7scKch11R2QwYwWoTicl2ZIVYrS3H8fCmL/ecNaYuxAv/ilD4JPbthM3zxhid6CV/yR5cDG0slit69NX3EmHBmvmoPzRF0b6OICOfn7aqEqAk/mMkxrpRMpqC53QwRATRwWzDuzqd7NiLV9hVZ+uAuT6Dp/1BzgX8iEVN7rGsMKa5mdq+mlSdJ6dNeXKbgpTw931yz5aYp6pn1sBaWhP0dqqe34xddsmeJ5MBYSGkgyfz0+0gwErZ0UgryZ/i8zFKJfj4qf2EHzTyBfYGSPQ8JphCYL74n96ElpcFrEDVJK5FFOJUQ8= derrick@derrickdeMacBook-Pro.local"
    ];
  };

  security.sudo = {
    enable = true;
    execWheelOnly = false;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = ["derrick"];
        host = "ALL";
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "derrick"
    "@wheel"
  ];

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
    ])
    ++ lib.optionals isX86_64 (with pkgs; [
      bottles
      lutris
    ]);

  services.resolved.enable = true;
  services.udev.packages = [pkgs.brightnessctl pkgs.networkmanagerapplet];
  programs.seahorse.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableKwallet = true;
  security.pam.services.login.kwallet.enable = true;
  environment.variables = {
    GASKPASS = "${pkgs.kdePackages.kdialog}/bin/kdialog";
    dbus-update-activation-environment = "--all";
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
  programs.nix-ld.dev.enable = true;
  system.stateVersion = "25.11";
}
