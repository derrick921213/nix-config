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
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.${user}.extraGroups = ["docker"];
}
