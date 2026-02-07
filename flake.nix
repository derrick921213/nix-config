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
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixgl,
    colmena,
    flake-utils,
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
    currentPkgs = import nixpkgs {
      system = builtins.currentSystem;
      config.allowUnfree = true;
    };
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
  in
    baseOutputs
    // {
      colmena = colmena.lib.makeHive ({
          meta = {
            nixpkgs = currentPkgs;
          };
        }
        // hiveHosts);
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.git
          pkgs.just
          colmena.packages.${system}.colmena
        ];
      };
    });
}
