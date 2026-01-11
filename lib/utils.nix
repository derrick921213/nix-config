# {}: let
#   isNixFile = name: builtins.match ".*\\.nix$" name != null;
#   isDisabled = name:
#     (builtins.match ".*\\.no$" name != null)
#     || (builtins.match ".*\\.no\\.nix$" name != null)
#     || (builtins.match ".*\\.nix\\.no$" name != null);
#   readDir = dir: builtins.readDir dir;
#   defaultExcludeDirs = [".git" "result" ".direnv"];
#   sortNames = names: builtins.sort (a: b: a < b) names;
#   nixFilesInDir = dir: {exclude ? ["default.nix" "lib.nix" "meta.nix"]}: let
#     entries = readDir dir;
#     names = sortNames (builtins.attrNames entries);
#     files =
#       builtins.filter (
#         n:
#           entries.${n}
#           == "regular"
#           && isNixFile n
#           && !isDisabled n
#           && !(builtins.elem n exclude)
#       )
#       names;
#   in
#     map (n: dir + "/${n}") files;
#   subDirsInDir = dir: {exclude ? []}: let
#     entries = readDir dir;
#     names = sortNames (builtins.attrNames entries);
#     dirs =
#       builtins.filter (
#         n:
#           entries.${n}
#           == "directory"
#           && !isDisabled n
#           && !(builtins.elem n (exclude ++ defaultExcludeDirs))
#       )
#       names;
#   in
#     map (n: dir + "/${n}") dirs;
#   nixFilesRecursive = dir: opts @ {
#     excludeFiles ? ["default.nix" "lib.nix" "meta.nix"],
#     excludeDirs ? [],
#   }: let
#     thisLevel = nixFilesInDir dir {exclude = excludeFiles;};
#     subdirs = subDirsInDir dir {exclude = excludeDirs;};
#     below = builtins.concatLists (map (d: nixFilesRecursive d opts) subdirs);
#   in
#     thisLevel ++ below;
#   # ---------- imports helpers ----------
#   importsFromDir = dir: nixFilesInDir dir {};
#   importsFromTree = dir: nixFilesRecursive dir {};
#   importsFromDirWith = dir: {exclude ? ["default.nix" "lib.nix" "meta.nix"]}:
#     nixFilesInDir dir {inherit exclude;};
#   importsFromTreeWith = dir: {
#     excludeFiles ? ["default.nix" "lib.nix" "meta.nix"],
#     excludeDirs ? [],
#   }:
#     nixFilesRecursive dir {inherit excludeFiles excludeDirs;};
# in {
#   inherit
#     isNixFile
#     isDisabled
#     nixFilesInDir
#     nixFilesRecursive
#     importsFromDir
#     importsFromTree
#     importsFromDirWith
#     importsFromTreeWith
#     ;
# }
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

  baseNameOf = path: let
    s = toString path;
    m = builtins.match ".*/([^/]+)$" s;
  in
    if m == null
    then s
    else builtins.elemAt m 0;

  nixNamedFileInDir = dir: {excludeFiles ? ["default.nix" "lib.nix" "meta.nix"]}: let
    entries = readDir dir;
    bn = baseNameOf dir;
    fname = "${bn}.nix";
  in
    if
      (entries ? ${fname})
      && entries.${fname} == "regular"
      && isNixFile fname
      && !isDisabled fname
      && !(builtins.elem fname excludeFiles)
    then [(dir + "/${fname}")]
    else [];

  # Recursive: traverse subdirs, but per-dir only import the named file.
  nixFilesRecursive = dir: opts @ {
    excludeFiles ? ["default.nix" "lib.nix" "meta.nix"],
    excludeDirs ? [],
  }: let
    thisLevel = nixNamedFileInDir dir {inherit excludeFiles;};
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
