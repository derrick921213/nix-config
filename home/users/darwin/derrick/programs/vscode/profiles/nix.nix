{
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
}
