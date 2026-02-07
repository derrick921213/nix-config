default:
    just --list

# 自動取得主機名稱與系統類型
hostname := `hostname | cut -d "." -f 1`
os_type := `uname -s`

# ---------- 基礎維護 ----------

# 更新所有 Flake inputs
@update:
    nix flake update

@show:
    nix flake show

# 檢查語法錯誤
@check:
    nix flake check --show-trace

# 列出所有主機定義 (需安裝 jq)
@show-hosts:
    nix eval .#hosts --json | jq

# 清理舊世代與垃圾
@gc:
    echo "Cleaning up old generations..."
    sudo nix-collect-garbage -d
    nix-collect-garbage --delete-older-than 7d
    nix-store --gc

# ---------- 本地系統切換 (NixOS / Darwin) ----------

# 自動判斷系統並執行 switch
@switch:
    if [ "{{os_type}}" = "Darwin" ]; then \
        just switch-macos {{hostname}}; \
    else \
        just switch-nixos {{hostname}}; \
    fi

# macOS: 編譯並切換
@switch-macos host=hostname:
    echo "Switching nix-darwin config for {{host}}..."
    nix build ".#darwinConfigurations.{{host}}.system"
    sudo ./result/sw/bin/darwin-rebuild switch --flake ".#{{host}}"

# NixOS: 編譯並切換
@switch-nixos host=hostname:
    echo "Switching NixOS config for {{host}}..."
    sudo nixos-rebuild switch --flake .#{{host}}

# ---------- Home Manager (CLI Tools) ----------

# 本地 HM 建置測試
@hm-build host=hostname:
    home-manager build --flake .#{{host}}

# 本地 HM 切換
@hm-switch host=hostname:
    home-manager switch --flake .#{{host}}

# ---------- 遠端部署 (Deploy-RS) ----------

# 部署 NixOS 節點 (會自動補上前綴)
@deploy-nixos host:
    deploy .#nixos-{{host}} -- --no-warn-dirty

# 部署 Standalone HM 節點 (會自動補上前綴)
@deploy-hm host:
    deploy .#hm-{{host}} -- --no-warn-dirty

# ---------- Colmena (NixOS 叢集管理) ----------

[group('colmena')]
cbuild:
    colmena build

[group('colmena')]
capply:
    colmena apply

[group('colmena')]
capply-on host *args="":
    colmena apply --on {{host}} {{args}}

# ---------- 補助工具 ----------

# 傳送 SSH Key 到遠端
upload-ssh-key user host:
    @ssh-copy-id -i ~/.ssh/id_rsa.pub {{user}}@{{host}}