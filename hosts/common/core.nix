{
  pkgs,
  inputs,
  self,
  user,
  hostname,
  ...
}: {
  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@admin" "derrick" "@wheel"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    channel.enable = true;
  };

  networking.hostName = hostname;
  time.timeZone = "Asia/Taipei";

  users.users.${user} =
    {
      home =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${user}"
        else "/home/${user}";
      shell = pkgs.zsh;
    }
    // (pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      description = "derrick";
      isNormalUser = true;
      extraGroups = [];
      hashedPassword = "$6$imjFfK.gjd3R5Tb3$0qqFQPLqUZ9oFP38736p3Q.VZz9c0w1Uepdbf6.ulXhWJx1gcgO6zL0pYQqlCHmjPYTflm3wIT4eTswkvjNxf1";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq3fqTChvwq6LS6MgIhUHtIAeTIt8NYtWLWeFM4fv0uqHBR8RGBpQICxUmhfuW4cIX3DfCTSlrmgStjQKJUGfR9LHHAJZfRc7eKlWDmj4h6Pfez+cv+dZp7i6FW4PbbKa5u0DnZqoUcjqsPBAW/xnNrKuFso2GBQDVL/ynvvwp/8o+wHUR5f4n6Gshy2uFTx35gtEXLMd/BA+I7scKch11R2QwYwWoTicl2ZIVYrS3H8fCmL/ecNaYuxAv/ilD4JPbthM3zxhid6CV/yR5cDG0slit69NX3EmHBmvmoPzRF0b6OICOfn7aqEqAk/mMkxrpRMpqC53QwRATRwWzDuzqd7NiLV9hVZ+uAuT6Dp/1BzgX8iEVN7rGsMKa5mdq+mlSdJ6dNeXKbgpTw931yz5aYp6pn1sBaWhP0dqqe34xddsmeJ5MBYSGkgyfz0+0gwErZ0UgryZ/i8zFKJfj4qf2EHzTyBfYGSPQ8JphCYL74n96ElpcFrEDVJK5FFOJUQ8= derrick@derrickdeMacBook-Pro.local"
      ];
    });

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    just
    git
    curl
    wget
    vim
    neovim
    htop
    tmux
    tree
    ripgrep
    fd
    jq
    alejandra
    neofetch
    mkcert
  ];
  programs = {
    zsh.enable = true;
    nix-index.enable = true;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs self user;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    };
    backupFileExtension = "backup";
    users.${user} = {
      imports = let
        isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
        platformDir =
          if isDarwin
          then "darwin"
          else "nixos";
      in [
        (import (self + "/home/users/${platformDir}/${user}.nix"))
      ];
    };
  };
}
