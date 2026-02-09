{
  self,
  user,
  ...
}: {
  imports = [
    (import (self + "/home/users/hm/${user}.nix"))
  ];
}
