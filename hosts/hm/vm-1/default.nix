{ self, user, ... }: {
  # 引入該使用者通用的配置
  imports = [
    (import (self + "/home/users/hm/${user}.nix"))
  ];
}