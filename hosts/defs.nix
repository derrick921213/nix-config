{self}: let
  discoverHosts = category: let
    base = self + "/hosts/${category}";
    entries =
      if builtins.pathExists base
      then builtins.readDir base
      else {};
    names = builtins.filter (n: entries.${n} == "directory") (builtins.attrNames entries);

    one = name: let
      metaPath = base + "/${name}/meta.nix";
      meta =
        if builtins.pathExists metaPath
        then import metaPath {inherit self;}
        else throw "Missing ${category} host meta: ${toString metaPath}";

      modulePath = base + "/${name}/default.nix";
    in {
      ${name} = meta // {module = modulePath;};
    };

    merge = builtins.foldl' (acc: x: acc // x) {};
  in
    merge (map one names);
in {
  darwin = discoverHosts "darwin";
  nixos = discoverHosts "nixos";
  hm = discoverHosts "hm";
}
