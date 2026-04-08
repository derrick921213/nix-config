{user, ...}: {
  environment.systemPackages = with pkgs; [
    scrcpy
  ];

  programs.adb.enable = true;
  users.users.${user}.extraGroups = ["adbusers"];
}
