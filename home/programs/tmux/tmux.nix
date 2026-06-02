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
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      resurrect
    ];

    extraConfig = ''
      ##### Terminal / colors #####
      # Use tmux terminfo and enable truecolor
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ",*:Tc"

      ##### Index #####
      set -g base-index 1
      setw -g pane-base-index 1

      ##### Pane split (keep cwd) #####
      unbind '"'
      unbind %
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'

      ##### Move between panes (vim-like) #####
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      ##### Resize panes #####
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      ##### Copy mode (vi) #####
      setw -g mode-keys vi

      ##### Activity alerts #####
      setw -g monitor-activity on
      set -g visual-activity on

      ##### Status bar layout #####
      set -g status-justify centre
      set -g status-left-length 40
      set -g status-interval 60

      ##### Theme (truecolor, Tokyonight-ish; stable across terminals) #####
      # Background / foreground baseline
      set -g status-style "fg=#c0caf5,bg=#1a1b26"

      # Left / right content
      set -g status-left  "#[fg=#9ece6a]Session: #S #[fg=#e0af68]W#I #[fg=#7dcfff]P#P"
      set -g status-right "#[fg=#7dcfff]%d %b %R #[fg=#bb9af7]#H"

      # Window list
      setw -g window-status-style "fg=#7aa2f7,bg=default,dim"
      setw -g window-status-current-style "fg=#1a1b26,bg=#e0af68,bold"

      # Pane borders
      set -g pane-border-style "fg=#414868"
      set -g pane-active-border-style "fg=#7aa2f7"

      # Message / command line
      set -g message-style "fg=#c0caf5,bg=#1a1b26"

      set -s set-clipboard on

      ##### Reload #####
      # Home Manager 實際生成的檔案通常在 ~/.config/tmux/tmux.conf
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded!"
    '';
  };
}
