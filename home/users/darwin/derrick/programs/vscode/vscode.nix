{
  pkgs,
  lib,
  ...
}: let
  firefly = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ankitcode";
      name = "firefly";
      version = "4.0.0";
      sha256 = "sha256-CUu7GHp4ks0y4X0UuAA5bROU2Mc2BJHQttmq4gcv1wY=";
    };
  };
  path-autocomplete = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ionutvmi";
      name = "path-autocomplete";
      version = "1.25.0";
      sha256 = "sha256-iz32o1znwKpbJSdrDYf+GDPC++uGvsCdUuGaQu6AWEo=";
    };
  };
  path-intellisense = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "christian-kohler";
      name = "path-intellisense";
      version = "2.10.0";
      sha256 = "sha256-bE32VmzZBsAqgSxdQAK9OoTcTgutGEtgvw6+RaieqRs=";
    };
  };
in {
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        # vscode 全域設定
        extensions = with pkgs.vscode-extensions; [
          vscodevim.vim
          ms-ceintl.vscode-language-pack-zh-hant
          editorconfig.editorconfig
          mikestead.dotenv
          firefly
          pkief.material-icon-theme
          mhutchie.git-graph
          oderwat.indent-rainbow
          path-autocomplete
          path-intellisense
        ];
        userSettings = {
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.fontSize" = 14;
          "files.autoSave" = "afterDelay";
          "editor.formatOnSave" = true;
        };
      };
      Rust = {
        extensions = with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          fill-labs.dependi
          aaron-bond.better-comments
          alefragnani.bookmarks
          skellock.just
        ];
        userSettings = {
          "rust-analyzer.check.command" = "clippy";
          "rust-analyzer.cargo.features" = "all";
        };
      };
      Nix = {
        extensions = with pkgs.vscode-extensions; [
          kamadorueda.alejandra
          bbenoist.nix
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.formatterPath" = "alejandra";
        };
      };
    };
  };
}
