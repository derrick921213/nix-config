{
  pkgs,
  common,
  ...
}: {
  Python = {
    extensions =
      common.commonExtensions
      ++ (with pkgs.vscode-extensions; [
        ms-python.python
        charliermarsh.ruff
        detachhead.basedpyright
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
        "python.terminal.activateEnvironment" = true;
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
