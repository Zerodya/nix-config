{
  # Hyprland extra configuration imported in host's home.nix
  wayland.windowManager.hyprland.extraConfig = ''

    # EXTRA CONFIGURATION
    
    # Run at boot
    source = ./eva01/autorun.conf

    # Raw mouse input
    input {
        sensitivity = 0 # -1.0 - 1.0
        accel_profile = flat
    }

    # Switch between keyboard layouts
    bind = $mod, SPACE, exec, hyprctl switchxkblayout htltek-gaming-keyboard next

    # Tearing
    general { 
        allow_tearing = true 
    }
    windowrulev2 = immediate, class:^(r5apex|eldenring|steam_app_524220)(.*)$ # Games with tearing

    # Freeze or resume a program/game process
    bind = , PAUSE, exec, ~/git/path/hyprfreeze/hyprfreeze -a

    # Turn monitor on
    bind = $mod SHIFT, F1, exec, ~/scripts/screenON

    # Restart audio streaming server
    bind = $mod ALT, F, exec, ~/scripts/ffplay_server.sh
  '';
}