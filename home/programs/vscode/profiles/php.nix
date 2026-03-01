{
  pkgs,
  common,
  ...
}: {
  Php = {
    extensions = with pkgs.vscode-extensions; [
      xdebug.php-debug
      bmewburn.vscode-intelephense-client
    ];
  };
}
