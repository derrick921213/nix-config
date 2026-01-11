{
  pkgs,
  user,
  ...
}: {
  networking.hostName = "derrickdexunijiqi";
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };
  # 如果你有特定機器才要的套件，就放這
  # environment.systemPackages = with pkgs; [ ... ];
  homebrew = {
    enable = true;
    casks = [
      "hammerspoon"
      "firefox"
      "iina"
      "dropshelf"
    ];
    onActivation.cleanup = "zap";
  };
}
