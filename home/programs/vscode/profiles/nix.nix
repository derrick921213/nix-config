{
  pkgs,
  common,
  ...
}: {
  Nix = {
    extensions = with pkgs.vscode-extensions; [
      kamadorueda.alejandra
      ms-python.python
      bbenoist.nix
      skellock.just
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "alejandra";
    };
  };
}
