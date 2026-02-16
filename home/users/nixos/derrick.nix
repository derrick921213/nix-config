{pkgs, ...}: let
in {
  imports = [
    ../core.nix
    ../../profiles/hyprland.nix
    ../../profiles/qtile.nix
    ./programs/rofi.nix
    # ./programs/yad.nix
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
  home.sessionVariables = {
    #   GTK_IM_MODULE = pkgs.lib.mkForce "fcitx5";
    #   QT_IM_MODULE = pkgs.lib.mkForce "fcitx5";
    #   XMODIFIERS = pkgs.lib.mkForce "@im=fcitx5";
    SAL_USE_VCLPLUGIN = "gtk3";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
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
  home.packages = with pkgs; [
    pkgs.libnotify
    pkgs.coreutils
    pkgs.yad
    libreoffice-still
    languagetool
    hunspell
    hunspellDicts.en_US

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
      # 文書檔案 (Word, Excel, PPT)
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"];
      "application/msword" = ["writer.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["calc.desktop"];
      "application/vnd.ms-excel" = ["calc.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop"];
      "application/vnd.ms-powerpoint" = ["impress.desktop"];

      # 開放格式 (ODT, ODS, ODP)
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"];

      # PDF (如果你也想用 LibreOffice 開啟 PDF 的話，通常建議用專門的閱讀器，但這裡示範寫法)
      # "application/pdf" = [ "draw.desktop" ];
    };
  };
  systemd.user.startServices = "sd-switch";
}
