{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty
  ];

  home.file.".config/alacritty/alacritty.toml".text = ''
    [window]
    padding = { x = 12, y = 10 }
    dynamic_padding = true

    [font]
    normal = { family = "JetBrainsMono Nerd Font" }
    size = 14

    [cursor]
    style = "Block"

    [terminal]

    [terminal.shell]
    program = "/bin/zsh"
    args = ["-l"]
  '';
}
