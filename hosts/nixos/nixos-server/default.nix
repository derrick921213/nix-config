{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-server";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  users.users.derrick = {
    isNormalUser = true;
    description = "derrick";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq3fqTChvwq6LS6MgIhUHtIAeTIt8NYtWLWeFM4fv0uqHBR8RGBpQICxUmhfuW4cIX3DfCTSlrmgStjQKJUGfR9LHHAJZfRc7eKlWDmj4h6Pfez+cv+dZp7i6FW4PbbKa5u0DnZqoUcjqsPBAW/xnNrKuFso2GBQDVL/ynvvwp/8o+wHUR5f4n6Gshy2uFTx35gtEXLMd/BA+I7scKch11R2QwYwWoTicl2ZIVYrS3H8fCmL/ecNaYuxAv/ilD4JPbthM3zxhid6CV/yR5cDG0slit69NX3EmHBmvmoPzRF0b6OICOfn7aqEqAk/mMkxrpRMpqC53QwRATRwWzDuzqd7NiLV9hVZ+uAuT6Dp/1BzgX8iEVN7rGsMKa5mdq+mlSdJ6dNeXKbgpTw931yz5aYp6pn1sBaWhP0dqqe34xddsmeJ5MBYSGkgyfz0+0gwErZ0UgryZ/i8zFKJfj4qf2EHzTyBfYGSPQ8JphCYL74n96ElpcFrEDVJK5FFOJUQ8= derrick@derrickdeMacBook-Pro.local"
    ];
    packages = with pkgs; [
      bat
    ];
  };
  security.sudo = {
    enable = true;
    execWheelOnly = false;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = ["derrick"];
        host = "ALL";
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
  #nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "25.11"; # Did you read the comment?
}
