{pkgs, ...}: let
in {
  imports = [
    ../core.nix
    ../../profiles/hyprland.nix
    ../../profiles/qtile.nix
    ./programs/rofi.nix
    ./programs/yad.nix
  ];
  home.username = "derrick";
  home.homeDirectory = "/home/derrick";
  xdg.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true; # 如果你用 X11
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Regular"; # 需確保 pkgs 有安裝對應主題
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };
  # home.sessionVariables = {
  #   GTK_IM_MODULE = pkgs.lib.mkForce "fcitx5";
  #   QT_IM_MODULE = pkgs.lib.mkForce "fcitx5";
  #   XMODIFIERS = pkgs.lib.mkForce "@im=fcitx5";
  # };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chewing # 新酷音 (注音輸入法)
      fcitx5-gtk # GTK 應用程式支援
      qt6Packages.fcitx5-configtool
      fcitx5-tokyonight
      fcitx5-nord
    ];
  };
  # home.packages = with pkgs; [
  # ];
}
