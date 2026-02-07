{
  pkgs,
  common,
  ...
}: {
  Rust = {
    extensions =
      common.commonExtensions
      ++ (with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        fill-labs.dependi
        aaron-bond.better-comments
        alefragnani.bookmarks
        skellock.just
      ]);
    userSettings =
      common.commonUserSettings
      // {
        "rust-analyzer.check.command" = "clippy";
        "rust-analyzer.cargo.features" = "all";
      };
  };
}
