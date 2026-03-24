{
  config,
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
    extraOptions = "--userland-proxy=true";
    package = pkgs.docker.override {
      buildxSupport = true;
    };
    daemon.settings = {
      # dns = ["1.1.1.1" "8.8.8.8"];
      "insecure-registries" = ["192.168.0.242" "192.168.0.242:5050" "gitlab.may-god.com:5050"];
      # "userland-proxy" = true;
    };
  };

  users.users.${user}.extraGroups = ["docker"];
}
