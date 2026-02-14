{
  config,
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings.default_session = {
      # user = "greeter";
      command = ''
        env LANG=en_US.UTF-8 ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --remember \
          --remember-session \
          --cmd dbus-run-session qtile start
      '';
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}
