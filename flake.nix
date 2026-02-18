{
  description = "Derrick Nix Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    nixpkgs-stable,
    nix-darwin,
    home-manager-stable,
    home-manager-unstable,
    nixgl,
    colmena,
    flake-utils,
    deploy-rs,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix {
      inherit self nixpkgs nixpkgs-stable nix-darwin inputs;
      home-manager-stable = inputs.home-manager-stable;
      home-manager-unstable = inputs.home-manager-unstable;
    };
    baseOutputs = mkHost.mkOutputs {
      inherit inputs;
      overlays = [nixgl.overlay];
    };
    defs = import (self + "/hosts/defs.nix") {inherit self inputs;};
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
    in
      (nixpkgs.lib.mapAttrs' (name: spec: let
        nodeSystem = spec.system or "x86_64-linux";
        deploy-lib = deploy-rs.lib.${nodeSystem};
      in {
        name = "nixos-${name}";
        value = {
          hostname = spec.hostip or name;
          remoteBuild = spec.remoteBuild or true;
          # magicRollback = false;
          confirmTimeout = 120;
          sshUser = spec.user or "derrick";
          sudo = "/run/wrappers/bin/sudo -u";
          profiles.system = {
            user = "root";
            path = deploy-lib.activate.nixos baseOutputs.nixosConfigurations.${name};
          };
        };
      }) (defs.nixos or {}))
      // (nixpkgs.lib.mapAttrs' (name: spec: let
        nodeSystem = spec.system or "x86_64-linux";
        deploy-lib = deploy-rs.lib.${nodeSystem};
      in {
        name = "hm-${name}";
        value = {
          sudo = "/run/wrappers/bin/sudo -u";
          confirmTimeout = 120;
          sshUser = spec.user or "derrick";
          hostname = spec.hostip or name;
          remoteBuild = spec.remoteBuild or true;
          profiles.home-manager = {
            user = spec.user or "derrick";
            path = deploy-lib.activate.home-manager baseOutputs.homeConfigurations.${name};
          };
        };
      }) (defs.hm or {}));
  in
    baseOutputs
    // {
      colmenaHive = colmena.lib.makeHive ({
          meta = {
            nixpkgs = import nixpkgs-stable {
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
      # checks = deploy-lib.deployChecks self.deploy;

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.git
          pkgs.just
          colmena.packages.${system}.colmena
          deploy-rs.packages.${system}.deploy-rs
          pkgs.hyprls
          home-manager-unstable.packages.${system}.home-manager
        ];
      };
    });
}
