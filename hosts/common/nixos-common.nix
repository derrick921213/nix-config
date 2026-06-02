{pkgs, ...}: {
  imports = [
    ./core.nix
  ];
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
  services.resolved.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.dev.enable = true;
  security.rtkit.enable = true;
  networking.networkmanager.enable = true;
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
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-m17n
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
      fcitx5-tokyonight
      fcitx5-nord
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
  system.stateVersion = "25.11";
}
