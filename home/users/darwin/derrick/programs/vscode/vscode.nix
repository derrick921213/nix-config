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

  commonExtensions = with pkgs.vscode-extensions; [
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
    gruntfuggly.todo-tree
  ];
  commonUserSettings = {
    "editor.fontFamily" = "JetBrainsMono Nerd Font";
    "editor.fontSize" = 16;
    "files.autoSave" = "afterDelay";
    "editor.formatOnSave" = true;
    "workbench.colorTheme" = "FireFly Pro Bright";
    "workbench.iconTheme" = "material-icon-theme";
    "git.enableSmartCommit" = true;
    "security.workspace.trust.untrustedFiles" = "open";
    "displayLanguage" = "zh-hant";
    "update.mode" = "none";
    "update.enableWindowsBackgroundUpdates" = false;
    "explorer.confirmDragAndDrop" = false;
    "git.autofetch" = true;
    "editor.fontLigatures" = "'ss08', 'calt', 'cv01'";
    "editor.stickyScroll.enabled" = true;
    "editor.stickyScroll.scrollWithEditor" = true;
    "editor.wordWrap" = "on";
    "git.confirmSync" = false;
    "editor.wrappingIndent" = "indent";
    "highlight.regexes" = {
      "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *TODO(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" = {
        "filterFileRegex" = ".*(?<!CHANGELOG.md)$";
        "decorations" = [
          {
            "overviewRulerColor" = "#ffcc00";
            "backgroundColor" = "#ffcc00";
            "color" = "#1f1f1f";
            "fontWeight" = "bold";
          }
          {
            "backgroundColor" = "#ffcc00";
            "color" = "#1f1f1f";
          }
        ];
      };

      "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:FIXME|FIX|BUG|UGLY|DEBUG|HACK)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" = {
        "filterFileRegex" = ".*(?<!CHANGELOG.md)$";
        "decorations" = [
          {
            "overviewRulerColor" = "#cc0000";
            "backgroundColor" = "#cc0000";
            "color" = "#1f1f1f";
            "fontWeight" = "bold";
          }
          {
            "backgroundColor" = "#cc0000";
            "color" = "#1f1f1f";
          }
        ];
      };

      "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:REVIEW|OPTIMIZE|TSC)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" = {
        "filterFileRegex" = ".*(?<!CHANGELOG.md)$";
        "decorations" = [
          {
            "overviewRulerColor" = "#00ccff";
            "backgroundColor" = "#00ccff";
            "color" = "#1f1f1f";
            "fontWeight" = "bold";
          }
          {
            "backgroundColor" = "#00ccff";
            "color" = "#1f1f1f";
          }
        ];
      };

      "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:IDEA)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" = {
        "filterFileRegex" = ".*(?<!CHANGELOG.md)$";
        "decorations" = [
          {
            "overviewRulerColor" = "#cc00cc";
            "backgroundColor" = "#cc00cc";
            "color" = "#1f1f1f";
            "fontWeight" = "bold";
          }
          {
            "backgroundColor" = "#cc00cc";
            "color" = "#1f1f1f";
          }
        ];
      };
    };
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.mouseWheelZoom" = true;
    "explorer.confirmDelete" = false;
    "workbench.activityBar.location" = "bottom";
    "window.customTitleBarVisibility" = "windowed";
  };
in {
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        # vscode 全域設定
        extensions = commonExtensions;
        userSettings = commonUserSettings;
      };
      Rust = {
        extensions =
          commonExtensions
          ++ (with pkgs.vscode-extensions; [
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            fill-labs.dependi
            aaron-bond.better-comments
            alefragnani.bookmarks
            skellock.just
          ]);
        userSettings =
          commonUserSettings
          // {
            "rust-analyzer.check.command" = "clippy";
            "rust-analyzer.cargo.features" = "all";
          };
      };
      Nix = {
        extensions =
          commonExtensions
          ++ (with pkgs.vscode-extensions; [
            kamadorueda.alejandra
            bbenoist.nix
          ]);
        userSettings =
          commonUserSettings
          // {
            "nix.enableLanguageServer" = true;
            "nix.formatterPath" = "alejandra";
          };
      };
    };
  };
}
