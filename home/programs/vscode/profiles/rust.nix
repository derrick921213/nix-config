{
  pkgs,
  common,
  ...
}: {
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
}
