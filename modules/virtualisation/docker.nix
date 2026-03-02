{
  config,
  pkgs,
  user,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
    daemon.settings = {
      dns = ["1.1.1.1" "8.8.8.8"];
    };
  };

  users.users.${user}.extraGroups = ["docker"];
}
