{...}: {
  programs.firefox = {
    enable = true;
    languagePacks = ["zh-TW" "en"];
    preferences = {
      "browser.startup.homepage" = "https://google.com.tw";
      #   "privacy.resistFingerprinting" = true;
    };

    policies = {
      DisableTelemetry = true;
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFormHistory = true;
      DefaultDownloadDirectory = "${home}/Downloads";
    };
    profiles.default.search = {
      force = true;
      default = "Google";
      privateDefault = "Google";
      excludedEngines = ["Bing" "Amazon.com" "eBay" "Wikipedia (en)"];

      engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };

        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };

        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nw"];
        };
      };
    };
  };
}
