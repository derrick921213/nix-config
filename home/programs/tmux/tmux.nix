{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "b";
    baseIndex = 1;
    escapeTime = 1;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      resurrect
    ];

    extraConfig = ''
      bind C-a send-prefix

      # 視窗與面板初始編號 (Home Manager 有時會覆寫，這裡再確認一次)
      setw -g pane-base-index 1

      # 面板分割
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      unbind '"'
      unbind %

      # 面板移動與縮放
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # 狀態列與配色 (根據你的原始配置)
      set -g status-justify centre
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]W#I #[fg=cyan]P#P"
      set -g status-right "#[fg=cyan]%d %b %R #[fg=magenta]#H"
      set -g status-interval 60

      # 視窗配色 (注意：較新版 tmux 語法略有不同，NixOS 建議使用新語法)
      setw -g window-status-style fg=cyan,bg=default,dim
      setw -g window-status-current-style fg=white,bg=yellow,bright

      # 面板配色
      set -g pane-border-style fg=green,bg=black
      set -g pane-active-border-style fg=white,bg=yellow

      # 訊息列
      set -g message-style fg=white,bg=black

      # 重載快捷鍵
      bind r source-file ~/.config/tmux/tmux.conf \; display "NixOS Tmux Config Reloaded!"
    '';
  };
}
