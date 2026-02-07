# Derrick Nix-Config
目前配置只有Mac

### Mac抓取哪些設定改哪些plist
```shell
sudo fs_usage -w | grep plist
```

## NixOS 專屬
### `hosts/nixos/{主機名}/meta.nix`
```nix
{...}: {
  # --- 基礎系統屬性 (Basic System Properties) ---
  # 目標機器的 CPU 架構，常見值有 "x86_64-linux", "aarch64-linux" (ARM)
  system = "aarch64-linux";
  # 該機器上的主要管理使用者名稱
  user = "derrick";
  # NixOS 相容性版本。重要：除非進行數據遷移，否則應維持安裝時的版本
  stateVersion = "25.11";

  # --- 部署設定 (Colmena Deployment Settings) ---
  
  deployment = {
    # 目標機器的 IP 地址或網域名稱
    targetHost = "172.16.125.137";
    
    # 遠端 SSH 登入帳號
    targetUser = "derrick";
    
    # SSH 連接埠，預設為 22
    targetPort = 22;
    
    # 是否在目標機器上執行編譯。
    # 當管理機 (如 Mac) 與目標機架構不同時，設為 true 可避免複雜的交叉編譯設定
    buildOnTarget = true;

    # [可選] 允許在本地執行 sudo 時不需輸入密碼
    # targetUser 必須在目標機器的 wheel 群組且 sudo 免密碼設定正確
    # privileged = true;

    # [可選] 部署策略：可以是 "switch" (預設), "boot", "test", "dry-activate"
    # action = "switch";
  };

  # --- 動態功能注入 (Dynamic Feature Injection) ---

  # 額外要載入的 Nix 模組路徑清單
  # 這是 Rust 管理系統控制主機功能的「開關」
  # 例如：extraModules = [ ../../shared/modules/docker.nix ];
  extraModules = [ ];

  # --- 自定義變數 (Custom Variables / Tags) ---
  
  # 這裡可以放任何你想傳遞給 default.nix 或其他模組的自定義資料
  # 例如：標記這台機器是 "production" 還是 "staging"
  # tags = [ "web-server" "database" ];
}
```