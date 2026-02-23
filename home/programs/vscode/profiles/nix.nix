{
  pkgs,
  common,
  ...
}: {
  Nix = {
    extensions =
      common.commonExtensions
      ++ (with pkgs.vscode-extensions; [
        kamadorueda.alejandra
        ms-python.python
        bbenoist.nix
        skellock.just
      ]);
    userSettings =
      common.commonUserSettings
      // {
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "alejandra";
      };
  };
}
