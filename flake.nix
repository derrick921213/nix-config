{
  description = "Derrick Nix Config";
  inputs = import ./inputs.nix;
  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixgl,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix {
      inherit self nixpkgs nix-darwin home-manager inputs;
    };
  in
    mkHost.mkOutputs {
      inherit inputs;
      overlays = [nixgl.overlay];
    };
}
