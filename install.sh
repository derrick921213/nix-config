#!/usr/bin/env bash
sudo nix run --experimental-features "nix-command flakes" \
  github:nix-community/disko#disko-install -- \
  --flake .#nixos-comp


#nix run github:nix-community/disko -- --mode disko-install .#nixos-comp
#nix run --experimental-features "nix-command flakes" github:nix-community/nixos-anywhere -- --build-on-remote --flake .#nixos-comp --generate-hardware-config nixos-generate-config ./hosts/nixos/nixos-comp/hardware-configuration.nix root@172.16.125.143