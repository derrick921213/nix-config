{
  pkgs,
  common,
}: {
  Python = {
    extensions =
      common.commonExtensions
      ++ (with pkgs.vscode-extensions; [
        ms-python.python
        charliermarsh.ruff
        ms-python.vscode-pylance
        detachhead.basedpyright
        tomasvergara.vscode-fastapi-snippets
        humao.rest-client
      ]);
    userSettings =
      common.commonUserSettings
      // {
        "python.defaultInterpreterPath" = ".venv/bin/python";
        "python.analysis.typeCheckingMode" = "strict";

        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
        };
        "ruff.enable" = true;
        "ruff.organizeImports" = true;
        "basedpyright.enable" = true;
        "python.testing.pytestEnabled" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.ruff" = true;
          "source.organizeImports.ruff" = true;
        };
      };
  };
}
