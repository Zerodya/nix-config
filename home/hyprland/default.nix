{ pkgs, ...}: {

  wayland.windowManager.hyprland.enable = true;
  
  # Extra packages
  home.packages = with pkgs; [
    hypridle # Idle daemon
    hyprlock # Lock screen
    hyprshot # Screenshot tool
    hyprprop # Prop tool
    hyprfreeze # Pause games 
    mpvpaper # Live wallpaper
    clipse # Clipboard manager
    wl-clip-persist # Persist clipboard
    wl-clipboard # Clipboard sharing
    xclip
    clipnotify
    wlr-randr # Wayland RandR
    wl-gammarelay-rs # Display brightness and temperature
  ];

  # Idle and lock screen
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

  # Extra configuration
  home.file.".config/hypr/autorun.conf".source = ./autorun.conf;
  home.file.".config/hypr/eva01/autorun.conf".source = ./eva01/autorun.conf;
  home.file.".config/hypr/eva02/autorun.conf".source = ./eva02/autorun.conf;

  # Systemd import environment 
  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  # Plugins
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprscrolling
  ];

  # Main configuration
  wayland.windowManager.hyprland.settings = {
    monitor = ",highrr,auto,1";

    source = "./autorun.conf";

    input = {
      kb_layout = "us,it,us";
      kb_variant = ",,colemak_dh_iso";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      numlock_by_default = true;

      follow_mouse = 1;
    };

    general = {
      gaps_in = 4;
      gaps_out = 12;
      border_size = 2;
      #"col.active_border" = "rgba(8cb6ffff)"; ## set by Stylix
      #"col.inactive_border" = "rgba(0c0e0faa)"; ## set by Stylix

      layout = "scrolling";
    };

    plugin = {
      hyprscrolling = {
        column_width = 0.49 ;
        fullscreen_on_one_column = false;
        explicit_column_widths = "0.49, 0.98";
        focus_fit_method = 1;
        follow_focus = true;
      };
    };

    decoration = {
      rounding = 20;

      blur = {
        enabled = false;
        size = 3;
        passes = 2;
        new_optimizations = true;
      };

      shadow = {
        enabled = false;
        range = 8;
        render_power = 2;
        #color = "rgba(1a1a1aee)"; ## set by Stylix
      };
    };

    animations = {
      enabled = true;

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 4, myBezier, popin 0%"
        "windowsIn, 1, 4, myBezier, popin 0%"
        "windowsOut, 1, 4, myBezier, slide bottom"
        "border, 1, 10, default"
        "fade, 1, 4, default"
        "workspaces, 1, 4, default, slidevert"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    binds = {
      scroll_event_delay = 300;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;

      vfr = true;
      vrr = 1;

      animate_mouse_windowdragging = false;

      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };

    workspace = [
      "1,persistent:true"
      "2,persistent:true"
      "3,persistent:true"
      "4,persistent:true"
      "5,persistent:true"
      "6,persistent:true"
    ];

    windowrulev2 = [
      # don't standby screen when fullscreen
      "idleinhibit fullscreen, class:.*"
      # clipse window size
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
      # Reaper in w6
      "workspace 6,class:^REAPER$"
    ];

    "$mod" = "SUPER";

    bind = [
      # Exec
      "$mod, RETURN, exec, kitty"
      "$mod, S, exec, nautilus"
      "$mod SHIFT, E, exit,"
      "$mod SHIFT, C, exec, kitty --class clipse -e clipse"
      "$mod, P, exec, solanum"
      "$mod, O, exec, blanket"

      # Shell IPC commands
      "$mod, D, exec, caelestia-shell ipc call drawers toggle launcher"
      "$mod, E, exec, caelestia-shell ipc call drawers toggle session"
      #"$mod, D, exec, noctalia-shell ipc call launcher toggle"
      #"$mod, E, exec, noctalia-shell ipc call sessionMenu toggle"

      # Window operations
      "$mod, Q, killactive,"
      "$mod, X, togglefloating,"
      "$mod, F, fullscreen, 1"
      "$mod SHIFT, F, fullscreen, 0"
      "$mod SHIFT, P, pin,"

      # Modes
      "$mod, Y, pseudo,"
      "$mod, T, togglesplit,"
      
      # Cycle windows
      "ALT, TAB, layoutmsg, focus r" # Hyprscrolling
      "ALT SHIFT, TAB, layoutmsg, focus l" # Hyprscrolling
      #"ALT, TAB, cyclenext,"
      #"ALT SHIFT, TAB, cyclenext, prev"
      "ALT, TAB, bringactivetotop,"
      "ALT SHIFT, TAB, bringactivetotop"

      # Move focus
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # Move window
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"

      # Switch workspaces with mod + [0-6]
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"

      # Move active window to a workspace with mod + SHIFT + [0-6]
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"

      # Workspace back and forth
      "$mod, TAB, workspace, previous"

      # Hyprscrolling
      "$mod, period, layoutmsg, move +col"
      "$mod, comma, layoutmsg, move -col"
      "$mod SHIFT, period, layoutmsg, movewindowto r"
      "$mod SHIFT, comma, layoutmsg, movewindowto l"
      "$mod SHIFT, semicolon, layoutmsg, movewindowto u"
      "$mod SHIFT, slash, layoutmsg, movewindowto d"
      "$mod, mouse_down, layoutmsg, focus r"
      "$mod, mouse_up, layoutmsg, focus l"
      "$mod, c, layoutmsg, colresize +conf"
      
      # Audio/Mic muting
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"

      # Media control
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # Screenshot a monitor
      ", PRINT, exec, hyprshot -m output"
      # Screenshot a region
      "$mod, PRINT, exec, hyprshot -m region"
      # Screenshot a region to clipboard
      "$mod SHIFT, PRINT, exec, hyprshot -m region --clipboard-only"
    ];

    bindm = [ # mouse
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    binde = [ # will repeat when held
      # Volume control
      ", XF86AudioRaiseVolume,exec,noctalia-shell ipc call volume increase"
      ", XF86AudioLowerVolume,exec,noctalia-shell ipc call volume decrease"
    ];

    bindl = [ # works also when lockscreen is active
      # Suspend
      "$mod, ESCAPE, exec, hyprlock & sleep 1 && systemctl suspend"
      # Standby
      "$mod SHIFT, ESCAPE, exec, sleep 1 && hyprctl dispatch dpms off"
      # Lock when closing laptop lid
      ",switch:Lid Switch, exec, hyprlock"
    ];

  };

}