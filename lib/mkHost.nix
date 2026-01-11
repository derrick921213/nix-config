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
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs self user;};
        }
      ];
    };

  mkNixosHost = {
    system,
    user,
    hostModule,
    pkgs,
    specialArgs ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = specialArgs // {inherit self user;};
      modules = [
        hostModule
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs self user;};
        }
      ];
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

    mkDarwinSet = nixpkgs.lib.mapAttrs (
      _: spec:
        mkDarwinHost {
          system = spec.system;
          user = spec.user;
          hostModule = spec.module;
          pkgs = mkPkgs spec.system;
          specialArgs = {inherit inputs;};
        }
    ) (defs.darwin or {});

    mkNixosSet = nixpkgs.lib.mapAttrs (
      _: spec:
        mkNixosHost {
          system = spec.system;
          user = spec.user;
          hostModule = spec.module;
          pkgs = mkPkgs spec.system;
          specialArgs = {inherit inputs;};
        }
    ) (defs.nixos or {});

    mkHomeSet = nixpkgs.lib.mapAttrs (
      _: spec:
        mkHome {
          system = spec.system;
          user = spec.user;
          homeModule = spec.module;
          pkgs = mkPkgs spec.system;
          extraSpecialArgs = {inherit inputs;};
        }
    ) (defs.hm or {});
  in {
    darwinConfigurations = mkDarwinSet;
    nixosConfigurations = mkNixosSet;
    homeConfigurations = mkHomeSet;
  };
in {
  inherit mkPkgsFor mkDarwinHost mkNixosHost mkHome mkOutputs;
}
