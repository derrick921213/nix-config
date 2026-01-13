# just 沒有參數預設建置系統config並switch
default: switch
hostname := `hostname | cut -d "." -f 1`

### macos
# 只編譯nix-darwin config 不切換
[macos]
build target_host=hostname flags="":
  @echo "Building nix-darwin config..."
  nix --extra-experimental-features 'nix-command flakes'  build ".#darwinConfigurations.{{target_host}}.system" {{flags}}

# 編譯nix-darwin config 並加上 --show-trace 旗標
[macos]
trace target_host=hostname: (build target_host "--show-trace")

# 編譯nix-darwin config 並切換
[macos]
switch target_host=hostname: (build target_host)
  @echo "switching to new config for {{target_host}}"
  sudo ./result/sw/bin/darwin-rebuild switch --flake ".#{{target_host}}"

### linux
# Build the NixOS configuration without switching to it
# [linux]
# build target_host=hostname flags="":
# 	nixos-rebuild build --flake .#{{target_host}} {{flags}}

# Build the NixOS config with the --show-trace flag set
# [linux]
# trace target_host=hostname: (build target_host "--show-trace")

# Build the NixOS configuration and switch to it.
# [linux]
# switch target_host=hostname:
#   sudo nixos-rebuild switch --flake .#{{target_host}}

## colmena
# cbuild:
#   colmena build

# capply:
#   colmena apply

# 更新flake 輸入來源到最新
update:
  nix flake update

## remote nix vm installation
# install IP:
#   ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
#     nix-shell -p git --run \"cd /root/ && \
#     if [ -d \"nix-config\" ]; then \
#         rm -rf nix-config; \
#     fi && \
#     git clone https://github.com/ironicbadger/nix-config.git && \
#     cd nix-config/lib/install && \
#     sh install-nix.sh\"'"

# 移除舊的OS世代及沒有使用的packages
gc:
  nix-collect-garbage -d
  nix-collect-garbage --delete-older-than 7d
  nix-store --gc

## manual command for initial bootstrapping
## sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
## nix --extra-experimental-features 'nix-command flakes' run nixpkgs#just

