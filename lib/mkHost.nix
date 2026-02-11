{
  self,
  nixpkgs,
  nixpkgs-stable,
  nix-darwin,
  home-manager-stable,
  home-manager-unstable,
  inputs,
  ...
}: let
  mkPkgsFor = {
    system,
    nixpkgsSrc ? nixpkgs,
    overlays ? [],
    allowUnfree ? true,
  }:
    import nixpkgsSrc {
      inherit system overlays;
      config.allowUnfree = allowUnfree;
    };

  mkDarwinHost = {
    system,
    user,
    hostModule,
    pkgs,
    specialArgs ? {},
  }:
    nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      specialArgs = specialArgs // {inherit self user;};
      modules = [
        hostModule
        (import (self + "/hosts/common/darwin-common.nix"))
      ];
    };

  mkNixosHost = {
    system,
    user,
    hostModule,
    pkgs,
    nixpkgsSrc,
    stateVersion ? "25.11",
    homeManagerModule,
    extraModules ? [],
    hostMeta ? {},
    specialArgs ? {},
  }:
    nixpkgsSrc.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = specialArgs // {inherit self user hostMeta;};
      modules =
        [
          hostModule
          homeManagerModule
          {system.stateVersion = stateVersion;}
          (import (self + "/hosts/common/nixos-common.nix"))
          #home-manager-stable.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.extraSpecialArgs = {inherit inputs self user;};
          # }
        ]
        ++ extraModules;
    };

  mkHome = {
    system,
    user,
    homeModule,
    pkgs,
    extraSpecialArgs ? {},
  }:
    home-manager-unstable.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [homeModule];
      extraSpecialArgs = extraSpecialArgs // {inherit self user;};
    };

  mkOutputs = {
    inputs,
    overlays ? [],
    allowUnfree ? true,
  }: let
    defs = import (self + "/hosts/defs.nix") {inherit self inputs;};

    # mkPkgs = system: mkPkgsFor {inherit system overlays allowUnfree;};
    mkPkgsUnstable = system:
      mkPkgsFor {
        inherit system overlays allowUnfree;
        nixpkgsSrc = nixpkgs;
      };

    mkPkgsStable = system:
      mkPkgsFor {
        inherit system overlays allowUnfree;
        nixpkgsSrc = nixpkgs-stable;
      };

    mkDarwinSet = nixpkgs.lib.mapAttrs' (name: spec: {
      name = name;
      value = mkDarwinHost {
        system = spec.system;
        user = spec.user;
        hostModule = spec.module;
        pkgs = mkPkgsUnstable spec.system;
        specialArgs = {
          inherit inputs;
          hostname = name;
        };
      };
    }) (defs.darwin or {});

    mkNixosSet = nixpkgs.lib.mapAttrs' (name: spec: {
      name = name;
      value = let
        channel = spec.pkgsChannel or "stable";
        pkgs' =
          if channel == "unstable"
          then mkPkgsUnstable spec.system
          else mkPkgsStable spec.system;

        homeManagerModule' =
          if channel == "unstable"
          then home-manager-unstable.nixosModules.home-manager
          else home-manager-stable.nixosModules.home-manager;

        nixpkgsSrc' =
          if channel == "unstable"
          then nixpkgs
          else nixpkgs-stable;
      in
        mkNixosHost {
          system = spec.system;
          user = spec.user;
          hostModule = spec.module;
          stateVersion = spec.stateVersion or "25.11";
          extraModules = spec.extraModules or [];
          hostMeta = spec;
          pkgs = pkgs';
          nixpkgsSrc = nixpkgsSrc';
          homeManagerModule = homeManagerModule';
          specialArgs = {
            inherit inputs;
            hostname = name;
          };
        };
    }) (defs.nixos or {});

    mkHomeSet = nixpkgs.lib.mapAttrs' (name: spec: {
      name = name;
      value = mkHome {
        system = spec.system;
        user = spec.user;
        homeModule = spec.module;
        pkgs = mkPkgsUnstable spec.system;
        extraSpecialArgs = {
          inherit inputs;
          hostname = name;
        };
      };
    }) (defs.hm or {});
  in {
    darwinConfigurations = mkDarwinSet;
    nixosConfigurations = mkNixosSet;
    homeConfigurations = mkHomeSet;
    hosts = {
      darwin = builtins.attrNames mkDarwinSet;
      nixos = builtins.attrNames mkNixosSet;
      home = builtins.attrNames mkHomeSet;
    };
  };
in {
  inherit mkPkgsFor mkDarwinHost mkNixosHost mkHome mkOutputs;
}
