{
  config,
  pkgs,
  ...
}: {
  home.file.".config/qtile/config.py".text = ''
    from libqtile import layout, bar, widget
    from libqtile.config import Key, Screen
    from libqtile.lazy import lazy

    mod = "mod4"
    keys = [
        Key([mod], "Return", lazy.spawn("kitty")),
        Key([mod], "q", lazy.window.kill()),
    ]
    layouts = [layout.MonadTall(), layout.Max()]
    screens = [Screen(top=bar.Bar([widget.Clock(format="%Y-%m-%d %H:%M")], 24))]
  '';
}
