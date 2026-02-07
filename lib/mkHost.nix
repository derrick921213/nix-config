{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  inputs,
}: let
  mkPkgsFor = {
    system,
    overlays ? [],
    allowUnfree ? true,
  }:
    import nixpkgs {
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
    stateVersion ? "25.11",
    extraModules ? [],
    hostMeta ? {},
    specialArgs ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = specialArgs // {inherit self user hostMeta;};
      modules =
        [
          hostModule
          {system.stateVersion = stateVersion;}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs self user;};
          }
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
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [homeModule];
      extraSpecialArgs = extraSpecialArgs // {inherit self user;};
    };

  mkOutputs = {
    inputs,
    overlays ? [],
    allowUnfree ? true,
  }: let
    defs = import (self + "/hosts/defs.nix") {inherit self;};

    mkPkgs = system: mkPkgsFor {inherit system overlays allowUnfree;};

    mkDarwinSet = nixpkgs.lib.mapAttrs' (name: spec: {
      name = name;
      value = mkDarwinHost {
        system = spec.system;
        user = spec.user;
        hostModule = spec.module;
        pkgs = mkPkgs spec.system;
        specialArgs = {
          inherit inputs;
          hostname = name;
        };
      };
    }) (defs.darwin or {});

    mkNixosSet = nixpkgs.lib.mapAttrs' (name: spec: {
      name = name;
      value = mkNixosHost {
        system = spec.system;
        user = spec.user;
        hostModule = spec.module;
        stateVersion = spec.stateVersion or "25.11";
        extraModules = spec.extraModules or [];
        hostMeta = spec;
        pkgs = mkPkgs spec.system;
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
        pkgs = mkPkgs spec.system;
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
