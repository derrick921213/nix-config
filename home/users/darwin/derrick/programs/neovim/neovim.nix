{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    rust-analyzer
    nixd
    alejandra
    rustfmt
    clippy
    cargo
    rustc
    tree-sitter
    ripgrep
    lazygit
  ];
  home.file.".config/nvim/init.lua".source = ./init.lua;
}
