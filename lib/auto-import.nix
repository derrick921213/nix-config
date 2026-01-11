{...}: let
  utils = import ./utils.nix {};
in {
  inherit
    (utils)
    nixFilesInDir
    nixFilesRecursive
    importsFromDir
    importsFromTree
    importsFromDirWith
    importsFromTreeWith
    ;
}
