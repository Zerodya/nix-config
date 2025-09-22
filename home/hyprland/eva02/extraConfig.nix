{
  # Hyprland extra configuration imported in host's home.nix
  wayland.windowManager.hyprland.extraConfig = ''

    # EXTRA CONFIGURATION
    
    # Run at boot
    source = ./eva02/autorun.conf

    # Touchpad input
    device {
      name = synps/2-synaptics-touchpad
      sensitivity = 0.3
    }

    # Trackpoint input
    device {
      name = tpps/2-elan-trackpoint
      sensitivity = -0.6
    }

    # Shared input
    input {
        accel_profile = adaptive

        touchpad {
            natural_scroll = false
        }
        scroll_method = edge
    }

    # Switch between keyboard layouts
    bind = $mod, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

    # Switch workspaces with 3 fingers
    gesture = 3, vertical, workspace

    # Brightness control
    binde=,XF86MonBrightnessDown,exec,brightnessctl set 5%-
    binde=,XF86MonBrightnessUp,exec,brightnessctl set +5%

    # Restart audio streaming server
    bind = $mod ALT, F, exec, ~/scripts/ffmpeg_client.sh
  '';
}