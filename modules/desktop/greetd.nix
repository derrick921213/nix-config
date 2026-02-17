{
  config,
  pkgs,
  lib,
  ...
}: {
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
  services.dbus.enable = true;
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}
