{}: let
  isNixFile = name: builtins.match ".*\\.nix$" name != null;

  isDisabled = name:
    (builtins.match ".*\\.no$" name != null)
    || (builtins.match ".*\\.no\\.nix$" name != null)
    || (builtins.match ".*\\.nix\\.no$" name != null);

  readDir = dir: builtins.readDir dir;

  defaultExcludeDirs = [".git" "result" ".direnv"];

  sortNames = names: builtins.sort (a: b: a < b) names;

  nixFilesInDir = dir: {exclude ? ["default.nix" "lib.nix" "meta.nix"]}: let
    entries = readDir dir;
    names = sortNames (builtins.attrNames entries);

    files =
      builtins.filter (
        n:
          entries.${n}
          == "regular"
          && isNixFile n
          && !isDisabled n
          && !(builtins.elem n exclude)
      )
      names;
  in
    map (n: dir + "/${n}") files;

  subDirsInDir = dir: {exclude ? []}: let
    entries = readDir dir;
    names = sortNames (builtins.attrNames entries);

    dirs =
      builtins.filter (
        n:
          entries.${n}
          == "directory"
          && !isDisabled n
          && !(builtins.elem n (exclude ++ defaultExcludeDirs))
      )
      names;
  in
    map (n: dir + "/${n}") dirs;

  nixFilesRecursive = dir: opts @ {
    excludeFiles ? ["default.nix" "lib.nix" "meta.nix"],
    excludeDirs ? [],
  }: let
    thisLevel = nixFilesInDir dir {exclude = excludeFiles;};
    subdirs = subDirsInDir dir {exclude = excludeDirs;};
    below = builtins.concatLists (map (d: nixFilesRecursive d opts) subdirs);
  in
    thisLevel ++ below;

  # ---------- imports helpers ----------
  importsFromDir = dir: nixFilesInDir dir {};
  importsFromTree = dir: nixFilesRecursive dir {};

  importsFromDirWith = dir: {exclude ? ["default.nix" "lib.nix" "meta.nix"]}:
    nixFilesInDir dir {inherit exclude;};

  importsFromTreeWith = dir: {
    excludeFiles ? ["default.nix" "lib.nix" "meta.nix"],
    excludeDirs ? [],
  }:
    nixFilesRecursive dir {inherit excludeFiles excludeDirs;};
in {
  inherit
    isNixFile
    isDisabled
    nixFilesInDir
    nixFilesRecursive
    importsFromDir
    importsFromTree
    importsFromDirWith
    importsFromTreeWith
    ;
}
