{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "git"
        "docker"
        "kubectl"
        "rust"
        "node"
      ];
    };

    shellAliases = {
      ls = "eza --icons auto";
      ll = "eza -lah --icons auto";
      cat = "bat";
      g = "git";
      k = "kubectl";
      mac-rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix-config#$(scutil --get LocalHostName)";
    };

    envExtra = ''
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      elif [ -e /etc/profile.d/nix.sh ]; then
        . /etc/profile.d/nix.sh
      fi
      export EDITOR=nvim
      #export RUST_BACKTRACE=1
    '';

    initContent = ''
      HISTSIZE=10000
      SAVEHIST=10000
      setopt share_history
      bindkey -e
      compdef ll=eza
      compdef ls=eza
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    eza #instead ls
    bat # instead cat
  ];
}
