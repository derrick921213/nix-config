{
  config,
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --remember \
          --remember-session \
          --cmd qtile start
      '';
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}
