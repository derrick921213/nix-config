{self, ...}: let
  auto = import (self + "/lib/auto-import.nix") {inherit self;};
in {
  imports = auto.importsFromDir ./.;
}
