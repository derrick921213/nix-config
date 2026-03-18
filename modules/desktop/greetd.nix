{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.variables = {
    KDE_SESSION_VERSION = "6";
    KDE_FULL_SESSION = "true";
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.greetd.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
  security.pam.services.greetd.enableKwallet = true;
  security.pam.services.login.kwallet.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = ''
        env LANG=en_US.UTF-8 ${pkgs.tuigreet}/bin/tuigreet \
          --time --asterisks --remember --remember-session \
          --cmd '${pkgs.dbus}/bin/dbus-run-session ${pkgs.zsh}/bin/zsh -l -c "source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh; exec qtile start"'
      '';
    };
  };
  services.dbus = {
    enable = true;
    # implementation = "broker";
  };
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}
