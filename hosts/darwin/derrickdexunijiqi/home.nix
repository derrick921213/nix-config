{
  self,
  user,
  ...
}: {
  home-manager.users.${user} = import (self + "/home/users/darwin/${user}/default.nix");
}
