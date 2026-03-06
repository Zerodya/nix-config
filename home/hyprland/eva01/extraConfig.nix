{
  # Host-specific extra configuration
  wayland.windowManager.hyprland.settings = {
    source = [ "./eva01/autorun.conf" ];

    # Raw mouse input
    input = {
      sensitivity = 0.5; # from -1.0 to 1.0
      accel_profile = "flat";
    };

    # Tearing
    general.allow_tearing = true;
    #windowrule = match:class ^(MainThrd|deadlock)(.*)$, immediate yes

    bind = [
      # Switch between keyboard layouts
      "$mod, SPACE, exec, hyprctl switchxkblayout htltek-gaming-keyboard next"

      # Freeze or resume a program/game process
      ", PAUSE, exec, hyprfreeze -a"

      # Turn monitor on
      "$mod SHIFT, F1, exec, ~/scripts/screenON"

      # Restart audio streaming server
      # "$mod ALT, F, exec, ~/scripts/ffplay_server.sh"
    ];
  };
}