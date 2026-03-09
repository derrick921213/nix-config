{
  hostMeta,
  lib,
  ...
}: let
  device = hostMeta.diskDevice or (throw "hostMeta.diskDevice is required for disko");
in {
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "@root" = {mountpoint = "/";};
                "@home" = {mountpoint = "/home";};
                "@nix" = {mountpoint = "/nix";};
              };
            };
          };
        };
      };
    };
  };
}
