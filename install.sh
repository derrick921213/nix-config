#!/usr/bin/env bash
sudo nix run --experimental-features "nix-command flakes" \
  github:nix-community/disko#disko-install -- \
  --flake .#nixos-comp
#nix run github:nix-community/disko -- --mode disko-install .#nixos-comp
