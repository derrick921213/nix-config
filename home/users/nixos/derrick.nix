{pkgs, ...}: let
in {
  imports = [
    ../core.nix
    ../../profiles/hyprland.nix
    ../../profiles/qtile.nix
    ./programs/rofi.nix
  ];
  home.username = "derrick";
  home.homeDirectory = "/home/derrick";
  xdg.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Regular";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };
  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk3";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chewing
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
      fcitx5-tokyonight
      fcitx5-nord
    ];
  };
  home.packages = with pkgs; [
    pkgs.libnotify
    pkgs.coreutils
    libreoffice-still
    languagetool
    hunspell
    hunspellDicts.en_US
    yad
    socat
    wev
    nwg-displays
    nwg-look
    wlr-randr

    (pkgs.writeShellScriptBin "notify-date" ''
      exec ${pkgs.libnotify}/bin/notify-send "Date" "$(${pkgs.coreutils}/bin/date)"
    '')

    (pkgs.writeShellScriptBin "notify-disk" ''
      exec ${pkgs.libnotify}/bin/notify-send "Disk" "$(${pkgs.coreutils}/bin/df -h / | ${pkgs.coreutils}/bin/tail -n 1)"
    '')
  ];
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"];
      "application/msword" = ["writer.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["calc.desktop"];
      "application/vnd.ms-excel" = ["calc.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop"];
      "application/vnd.ms-powerpoint" = ["impress.desktop"];
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"];
      # "application/pdf" = [ "draw.desktop" ];
    };
  };
  systemd.user.startServices = "sd-switch";
}
