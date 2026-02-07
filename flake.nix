{
  description = "Derrick Nix Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    colmena.url = "github:zhaofengli/colmena";
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixgl,
    colmena,
    flake-utils,
    deploy-rs,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix {
      inherit self nixpkgs nix-darwin home-manager inputs;
    };
    baseOutputs = mkHost.mkOutputs {
      inherit inputs;
      overlays = [nixgl.overlay];
    };
    defs = import (self + "/hosts/defs.nix") {inherit self;};
    hiveHosts =
      nixpkgs.lib.mapAttrs
      (
        hostName: spec: {
          name,
          nodes,
          ...
        }: {
          deployment =
            if spec ? deployment
            then spec.deployment
            else throw "Missing deployment in hosts/nixos/${hostName}/meta.nix";
          imports = baseOutputs.nixosConfigurations.${hostName}._module.args.modules 
                  or [(baseOutputs.nixosConfigurations.${hostName}.extendModules {})];
        }
      )
      (defs.nixos or {});
    mkDeployNodes = system: let
      deploy-lib = deploy-rs.lib.${system};
    in
      (nixpkgs.lib.mapAttrs' (name: spec: {
        name = "nixos-${name}";
        value = {
          hostname = spec.hostip or name;
          remoteBuild = spec.remoteBuild or false;
          profiles.system = {
            user = spec.user or "root";
            path = deploy-lib.activate.nixos baseOutputs.nixosConfigurations.${name};
          };
        };
      }) (defs.nixos or {}))
      // (nixpkgs.lib.mapAttrs' (name: spec: {
        name = "hm-${name}";
        value = {
          hostname = spec.hostip or name;
          remoteBuild = spec.remoteBuild or false;
          profiles.home-manager = {
            user = spec.user;
            path = deploy-lib.activate.home-manager baseOutputs.homeConfigurations.${name};
          };
        };
      }) (defs.hm or {}));
  in
    baseOutputs
    // {
      colmenaHive = colmena.lib.makeHive ({
          meta = {
            nixpkgs = import nixpkgs {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        }
        // hiveHosts);
    }
    // {
      deploy.nodes = mkDeployNodes "aarch64-darwin";
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      deploy-lib = deploy-rs.lib.${system};
    in {
      checks = deploy-lib.deployChecks self.deploy;

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.git
          pkgs.just
          colmena.packages.${system}.colmena
          deploy-rs.packages.${system}.deploy-rs
          home-manager.packages.${system}.home-manager
        ];
      };
    });
}
