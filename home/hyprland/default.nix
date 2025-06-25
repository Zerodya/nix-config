{ pkgs, ...}: {

  wayland.windowManager.hyprland.enable = true;
  
  # Extra packages
  home.packages = with pkgs; [
    hypridle # Idle daemon
    hyprlock # Lock screen
    hyprshot # Screenshot tool
    swww # Wallpaper
    mpvpaper # Live wallpaper
    clipse # Clipboard manager
    wl-clip-persist # Persist clipboard
    wl-clipboard # Clipboard sharing
    xclip
    clipnotify
    wlr-randr # Wayland RandR
    wl-gammarelay-rs # # Display brightness and temperature
  ];

  # Idle and lock screen
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

  # Extra configuration
  home.file.".config/hypr/autorun.conf".source = ./autorun.conf;
  home.file.".config/hypr/eva01/autorun.conf".source = ./eva01/autorun.conf;
  home.file.".config/hypr/eva02/autorun.conf".source = ./eva02/autorun.conf;

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

      layout = "dwindle";
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
        "windows, 1, 6, myBezier"
        "windowsOut, 1, 6, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 3, default"
        "workspaces, 1, 4, default, slidevert"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    binds = {
      allow_workspace_cycles = true;
      scroll_event_delay = 0;
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

    windowrulev2 = [
      # don't standby screen when fullscreen
      "idleinhibit fullscreen, class:.*"
      # float everything except kitty
      "float, class:.*"
      "tile, class:(kitty)"
      # clipse window size
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
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

      # Caelestia - use direct IPC commands
      "$mod, D, exec, qs -c caelestia ipc call drawers toggle launcher"
      "$mod, E, exec, qs -c caelestia ipc call drawers toggle session"

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
      "ALT, TAB, cyclenext,"
      "ALT, TAB, bringactivetotop,"
      "ALT SHIFT, TAB, cyclenext, prev"
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

      # Scroll through existing workspaces with mod + scroll
      "$mod, mouse_down, workspace, e-1"
      "$mod, mouse_up, workspace, e+1"
      
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
      ", XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
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