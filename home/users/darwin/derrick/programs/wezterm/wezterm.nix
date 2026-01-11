{pkgs, ...}: {
  home.packages = with pkgs; [
    wezterm
  ];
  home.file.".wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    return {
        front_end = "WebGpu",
        font = wezterm.font("JetBrainsMono Nerd Font"),
        font_size = 14,
        enable_tab_bar = true,
        hide_tab_bar_if_only_one_tab = true,
        window_padding = { left = 12, right = 12, top = 8, bottom = 8 },
        use_fancy_tab_bar = false,
        prefer_egl = true,
    }
  '';
}
