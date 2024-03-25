{
  # Hyprland extra configuration imported in host's home.nix
  wayland.windowManager.hyprland.extraConfig = ''

    # EXTRA CONFIGURATION
    
    # Run at boot
    source = ./eva02/autorun.conf

    # Smooth mouse input
    input {
        sensitivity = 0.3 # -1.3 - 1.3
        accel_profile = adaptive

        touchpad {
            natural_scroll = false
        }
        scroll_method = edge
    }

    # Switch between keyboard layouts
    bind = $mod, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

    # Switch workspaces with 3 fingers
    gestures {
        workspace_swipe = on
    }

    # Brightness control
    binde=,XF86MonBrightnessDown,exec,brightnessctl set 5%-
    binde=,XF86MonBrightnessUp,exec,brightnessctl set +5%

    # Restart audio streaming server
    bind = $mod ALT, F, exec, ~/scripts/ffmpeg_client.sh
  '';
}