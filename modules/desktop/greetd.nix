{
  config,
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --asterisks --time --cmd Hyprland";
      };
    };
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    tuigreet
  ];
}
