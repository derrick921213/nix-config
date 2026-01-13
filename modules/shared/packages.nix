{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    neovim
    htop
    tmux
    tree
    ripgrep
    fd
    jq
    alejandra
    home-manager
    neofetch
    mkcert
  ];
}
