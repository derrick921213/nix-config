from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen,ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess
from typing import Callable, Optional

MOD = "mod4"
ALT = "mod1"
SHIFT = "shift"
CONTROL = "control"
home = os.path.expanduser("~")
terminal = guess_terminal()

myTerm = "alacritty" 

# os.environ["PATH"] = ":".join([
#     "/run/current-system/sw/bin",
#     f"{home}/.nix-profile/bin",
#     "/etc/profiles/per-user/%s/bin" % os.environ.get("USER", ""),
#     "/nix/var/nix/profiles/default/bin",
#     "/run/wrappers/bin",
#     os.environ.get("PATH", ""),
# ])

@hook.subscribe.startup_once
def autostart():
    subprocess.run([home + "/.config/qtile/scripts/autostart.sh"])
    # size = os.environ.get("XCURSOR_SIZE", "24")
    # theme = os.environ.get("XCURSOR_THEME", "Bibata-Modern-Ice")
    # xrdb_cmd = f"Xcursor.theme: {theme}\nXcursor.size: {size}"
    # subprocess.run(["xrdb", "-merge"], input=xrdb_cmd, text=True)
    # subprocess.run(["xsetroot", "-cursor_name", "left_ptr"])

def sh(cmd: str):
    """Spawn via shell; prefer this for complex pipelines."""
    return lazy.spawn(f"zsh -lc {cmd!r}")

def maybe_layout(method_name: str, *args, fallback: Optional[Callable] = None):
    """
    Call layout method if it exists (prevents crashes on layouts missing methods).
    Example: maybe_layout("grow_left")
    """
    @lazy.function
    def _inner(qtile):
        lay = qtile.current_layout
        fn = getattr(lay, method_name, None)
        if callable(fn):
            fn(*args)
        elif fallback:
            fallback(qtile)
    return _inner

def notify(msg: str, title: str = "Qtile"):
    return sh(f'notify-send {title!r} {msg!r}')

# keys = [
#     Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
#     Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
#     Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
#     Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
#     Key([MOD], "space", lazy.layout.next(), desc="Move window focus to other window"),
#     # Move windows between left/right columns or move up/down in current stack.
#     # Moving out of range in Columns layout will create new column.
#     Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
#     Key([MOD, SHIFT], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
#     Key([MOD, SHIFT], "j", lazy.layout.shuffle_down(), desc="Move window down"),
#     Key([MOD, SHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),
#     # Grow windows. If current window is on the edge of screen and direction
#     # will be to screen edge - window would shrink.
#     Key([MOD, CONTROL], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
#     Key([MOD, CONTROL], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
#     Key([MOD, CONTROL], "j", lazy.layout.grow_down(), desc="Grow window down"),
#     Key([MOD, CONTROL], "k", lazy.layout.grow_up(), desc="Grow window up"),
#     Key([MOD], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
#     # Toggle between split and unsplit sides of stack.
#     # Split = all windows displayed
#     # Unsplit = 1 window displayed, like Max layout, but still with
#     # multiple stack panes
#     Key(
#         [MOD, SHIFT],
#         "Return",
#         lazy.layout.toggle_split(),
#         desc="Toggle between split and unsplit sides of stack",
#     ),
#     Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
#     # Toggle between different layouts as defined below
#     Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
#     Key([MOD], "q", lazy.window.kill(), desc="Kill focused window"),
#     Key(
#         [MOD],
#         "f",
#         lazy.window.toggle_fullscreen(),
#         desc="Toggle fullscreen on the focused window",
#     ),
#     Key([MOD], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
#     Key([MOD, CONTROL], "r", lazy.reload_config(), desc="Reload the config"),
#     Key([MOD, CONTROL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
#     Key([MOD], "d", lazy.spawn("rofi -show drun -show-icons"), desc='Run Launcher'),
#     Key([ALT], "Tab", lazy.spawn("rofi -show window -show-icons"), desc='Run Lanucher to switch window'),
#     Key(
#         [MOD, SHIFT], 
#         "s",
#         lazy.spawn('sh -c "maim -u -s | xclip -selection clipboard -t image/png -i && notify-send \\"截圖已儲存至剪貼簿\\" "'),
#         desc="Screenshot"
#     ),
#     Key(
#         [ALT, SHIFT],
#         "s",
#         lazy.spawn(
#             'sh -lc \''
#             'dir="$HOME/Pictures/Screenshots"; '
#             'mkdir -p "$dir"; '
#             'file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"; '
#             'maim -u -s "$file" && notify-send "Screenshot saved" "$file"'
#             '\''
#         ),
#         desc="Screenshot to file (select area)",
#     ),
#     Key(
#         [MOD, SHIFT], 
#         "a",
#         lazy.spawn('sh -c "maim -u | xclip -selection clipboard -t image/png -i && notify-send \\"截圖已儲存至剪貼簿\\" "'),
#         desc="Screenshot"
#     ),
#     Key(
#         [ALT, SHIFT],
#         "a",
#         lazy.spawn(
#             'sh -lc \''
#             'dir="$HOME/Pictures/Screenshots"; '
#             'mkdir -p "$dir"; '
#             'file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"; '
#             'maim "$file" && notify-send "Screenshot saved" "$file"'
#             '\''
#         ),
#         desc="Full screenshot (instant)",
#     ),
#     Key([MOD], "e", lazy.spawn("dolphin"), desc="File Manager"),
#     Key([MOD], "w", lazy.spawn("firefox"), desc="Web Browser"),
#     Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
#     Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
#     Key([], "XF86AudioMute",        lazy.spawn("pamixer -t")),
# ]

keys = [
    # ====== Global ======
    Key([MOD], "Return", lazy.spawn(terminal), desc="Terminal"),
    Key([MOD], "d", lazy.spawn("rofi -show drun -show-icons"), desc="App launcher"),
    Key([ALT], "Tab", lazy.spawn("rofi -show window -show-icons"), desc="Window switcher"),
    Key([ALT, SHIFT], "Tab", lazy.spawn("rofi -show window -show-icons"), desc="Window switcher (reverse)"),

    # 你原本的音量鍵
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioMute",        lazy.spawn("pamixer -t")),
]

window_mode = KeyChord(
    [], "w",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit window mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        Key([], "q", lazy.window.kill(), desc="Kill window"),
        Key([], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen"),
        Key([], "v", lazy.window.toggle_floating(), desc="Toggle floating"),
        Key([], "r", sh(home + "/.config/hypr/autostart.sh"), desc="Reload waybar/autostart"),
    ],
    mode=True,
    name="window"
)

move_mode = KeyChord(
    [], "m",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit move mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        # focus (HJKL)
        Key([], "h", lazy.layout.left(), desc="Focus left"),
        Key([], "l", lazy.layout.right(), desc="Focus right"),
        Key([], "k", lazy.layout.up(), desc="Focus up"),
        Key([], "j", lazy.layout.down(), desc="Focus down"),

        # move window (SHIFT+HJKL)
        Key([SHIFT], "h", lazy.layout.shuffle_left(), desc="Move window left"),
        Key([SHIFT], "l", lazy.layout.shuffle_right(), desc="Move window right"),
        Key([SHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),
        Key([SHIFT], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    ],
    mode=True,
    name="move"
)

resize_mode = KeyChord(
    [], "r",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit resize mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        Key([], "h", maybe_layout("grow_left"), desc="Grow left"),
        Key([], "l", maybe_layout("grow_right"), desc="Grow right"),
        Key([], "k", maybe_layout("grow_up"), desc="Grow up"),
        Key([], "j", maybe_layout("grow_down"), desc="Grow down"),
        Key([], "n", lazy.layout.normalize(), desc="Normalize"),
    ],
    mode=True,
    name="resize"
)

screenshot_mode = KeyChord(
    [], "s",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit screenshot mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        # S: 選取區域 → clipboard
        Key([], "s", sh('maim -u -s | xclip -selection clipboard -t image/png -i && notify-send "Screenshot" "saved to clipboard"'), desc="Area -> clipboard"),

        # A: 全螢幕 → clipboard
        Key([], "a", sh('maim -u | xclip -selection clipboard -t image/png -i && notify-send "Screenshot" "saved to clipboard"'), desc="Full -> clipboard"),

        # F: 選取區域 → file
        Key([], "f", sh(
            'dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; '
            'file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"; '
            'maim -u -s "$file" && notify-send "Screenshot saved" "$file"'
        ), desc="Area -> file"),

        # P: 全螢幕 → file
        Key([], "p", sh(
            'dir="$HOME/Pictures/Screenshots"; mkdir -p "$dir"; '
            'file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"; '
            'maim -u "$file" && notify-send "Screenshot saved" "$file"'
        ), desc="Full -> file"),
    ],
    mode=True,
    name="screenshot"
)

power_mode = KeyChord(
    [], "p",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit power mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        Key([], "l", sh("loginctl lock-session"), desc="Lock session"),
        Key([], "q", lazy.shutdown(), desc="Quit Qtile"),
        Key([], "r", sh("systemctl reboot"), desc="Reboot"),
        Key([], "p", sh("systemctl poweroff"), desc="Poweroff"),
    ],
    mode=True,
    name="power"
)

apps_mode = KeyChord(
    [], "a",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit apps mode"),
        Key([], "slash", lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Help"),

        Key([], "t", lazy.spawn(terminal), desc="Terminal"),
        Key([], "e", lazy.spawn("dolphin"), desc="File manager"),
        Key([], "b", lazy.spawn("firefox"), desc="Browser"),
        Key([], "d", lazy.spawn("rofi -show drun -show-icons"), desc="Launcher"),
    ],
    mode=True,
    name="apps"
)


leader = KeyChord(
    [MOD], "space",
    [
        Key([], "escape", lazy.ungrab_chord(), desc="Exit leader"),
        Key([], "space",  lazy.ungrab_chord(), desc="Exit leader"),
        Key([], "slash",  lazy.spawn(home + "/.config/hypr/scripts/show-mode-help.sh"), desc="Show mode help"),

        window_mode,
        resize_mode,
        move_mode,
        screenshot_mode,
        power_mode,
        apps_mode,
    ],
    mode=True,
    name="leader"
)
keys.append(leader)

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]


for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [MOD],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [MOD, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc=f"Switch to & move focused window to group {i.name}",
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            Key([MOD, SHIFT], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

groups.append(
    ScratchPad("scratchpad", [
        # 定義一個名為 "term" 的下拉式終端機
        DropDown("term", "alacritty", 
                 opacity=0.9,          # 透明度
                 height=0.6,           # 高度佔螢幕 60%
                 width=0.8,            # 寬度佔螢幕 80%
                 x=0.1, y=0.1,         # 顯示的位置偏移
                 on_focus_lost_hide=True # 當焦點離開時自動縮回去
        ),
    ]),
)

keys.extend([
    # 按下 mod + u 彈出/收起終端機
    Key([MOD], "u", lazy.group['scratchpad'].dropdown_toggle('term')),
])

colors = [
    ["#1a1b26", "#1a1b26"],  # bg        (primary.background)
    ["#a9b1d6", "#a9b1d6"],  # fg        (primary.foreground)
    ["#32344a", "#32344a"],  # color01   (normal.black)
    ["#f7768e", "#f7768e"],  # color02   (normal.red)
    ["#9ece6a", "#9ece6a"],  # color03   (normal.green)
    ["#e0af68", "#e0af68"],  # color04   (normal.yellow)
    ["#7aa2f7", "#7aa2f7"],  # color05   (normal.blue)
    ["#ad8ee6", "#ad8ee6"],  # color06   (normal.magenta)
    ["#0db9d7", "#0db9d7"],  # color15   (bright.cyan)
    ["#444b6a", "#444b6a"]   # color[9]  (bright.black)
]

# helper in case your colors are ["#hex", "#hex"]
def C(x): return x[0] if isinstance(x, (list, tuple)) else x

layout_theme = {
    "border_width" : 1,
    "margin" : 1,
    "border_focus" : colors[6],
    "border_normal" : colors[0],
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(**layout_theme),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Propo Bold",
    fontsize=16,
    padding=0,
    background=colors[0],
)


extension_defaults = widget_defaults.copy()

sep = widget.Sep(linewidth=1, padding=8, foreground=colors[9])

screens = [
    Screen(
        top=bar.Bar(
            widgets = [
                widget.Spacer(length = 8),
                widget.Image(
                    filename = "~/.config/qtile/icons/tonybtw.png",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn("rofi -show drun -show-icons")},
                ),
                widget.Prompt(
                    font = "Ubuntu Mono",
                    fontsize=14,
                    foreground = colors[1]
                ),
                widget.GroupBox(
                    fontsize = 18,
                    margin_y = 5,
                    margin_x = 5,
                    padding_y = 0,
                    padding_x = 2,
                    borderwidth = 3,
                    active = colors[8],
                    inactive = colors[9],
                    rounded = False,
                    highlight_color = colors[0],
                    highlight_method = "line",
                    this_current_screen_border = colors[7],
                    this_screen_border = colors [4],
                    other_current_screen_border = colors[7],
                    other_screen_border = colors[4],
                ),
                widget.TextBox(
                    text = '|',
                    font = "JetBrainsMono Nerd Font Propo Bold",
                    foreground = colors[9],
                    padding = 2,
                    fontsize = 14
                ),
                widget.CurrentLayout(
                    foreground = colors[1],
                    padding = 5
                ),
                widget.TextBox(
                    text = '|',
                    font = "JetBrainsMono Nerd Font Propo Bold",
                    foreground = colors[9],
                    padding = 2,
                    fontsize = 14
                ),
                widget.WindowName(
                    foreground = colors[6],
                    padding = 8,
                    max_chars = 40
                ),
                widget.GenPollText(
                    update_interval = 300,
                    func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
                    foreground = colors[3],
                    padding = 8, 
                    fmt = '{}',
                ),
                sep,
                # widget.CPU(
                #     foreground = colors[4],
                #     padding = 8, 
                #     mouse_callbacks = {'Button1': lambda: qtile.spawn(myTerm + ' -e btop')},
                #     format="CPU: {load_percent}%",
                # ),
                # sep,
                widget.Memory(
                    foreground = colors[8],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.spawn(myTerm + ' -e btop')},
                    # format = 'Mem: {MemUsed:.0f}{mm}',
                    format = 'Mem: {MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}',
                ),
                sep,
                widget.DF(
                    update_interval = 60,
                    foreground = colors[5],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('notify-disk')},
                    partition = '/',
                    format = '{uf}-{m} free',
                    fmt = 'Disk: {}',
                    visible_on_warn = False,
                ),
                sep,
                # widget.Battery(
                #     foreground=colors[6],           # pick a palette slot you like
                #     padding=8,
                #     update_interval=5,
                #     format='{percent:2.0%} {char} {hour:d}:{min:02d}',  # e.g. "73% ⚡ 1:45"
                #     fmt='Bat: {}',
                #     charge_char='',               # shown while charging
                #     discharge_char='',            # Nerd icon; use '-' if you prefer plain ascii
                #     full_char='✔',                 # when at/near 100%
                #     unknown_char='?',
                #     empty_char='!', 
                #     mouse_callbacks={
                #         'Button1': lambda: qtile.spawn(myTerm + ' -e upower -i $(upower -e | grep BAT)'),
                #     },
                # ),
                # sep,
                widget.GenPollText(
                    update_interval=1,
                    func=lambda: subprocess.check_output(
                        "pamixer --get-volume-human",
                        shell=True,
                        text=True
                    ).strip(),
                    fmt="Vol: {}",
                    mouse_callbacks={
                        'Button1': lambda: qtile.spawn("pavucontrol"),
                        'Button2': lambda: qtile.spawn("pamixer --toggle-mute"),
                        'Button4': lambda: qtile.spawn("pamixer -i 5"),
                        'Button5': lambda: qtile.spawn("pamixer -d 5"),
                    },
                ),
                sep,
                widget.Clock(
                    foreground = colors[8],
                    padding = 8, 
                    mouse_callbacks = {'Button1': lambda: qtile.spawn('notify-date')},
                    format = "%a, %b %d - %H:%M",
                ),
                widget.Systray(padding = 6),
                widget.Spacer(length = 8),
            ],
            margin=[0, 0, 0, 0], 
            size=30
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
# wl_xcursor_theme = None
# wl_xcursor_size = 12

wmname = "LG3D"
