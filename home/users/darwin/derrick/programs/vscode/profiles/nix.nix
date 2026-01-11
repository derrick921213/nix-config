{
  pkgs,
  common,
}: {
  Nix = {
    extensions =
      common.commonExtensions
      ++ (with pkgs.vscode-extensions; [
        kamadorueda.alejandra
        bbenoist.nix
      ]);
    userSettings =
      common.commonUserSettings
      // {
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "alejandra";
      };
  };
}
