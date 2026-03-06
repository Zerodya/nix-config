{
  # Host-specific extra configuration
  wayland.windowManager.hyprland.settings = {
    source = [ "./eva01/autorun.conf" ];

    device = [
      # Touchpad input
      {
        name = "synps/2-synaptics-touchpad";
        sensitivity = 0.3;
      }
      # Trackpoint input
      {
        name = "tpps/2-elan-trackpoint";
        sensitivity = -0.6;
      }
    ];

    # Shared input
    input = {
      accel_profile = "adaptive";
      touchpad = {
          natural_scroll = false;
      };
      scroll_method = "edge";
    };

    gesture = "3, vertical, workspace";

    bind = [
      # Switch between keyboard layouts
      "$mod, SPACE, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"

      # Restart audio streaming client
      #"$mod ALT, F, exec, ~/scripts/ffmpeg_client.sh"
    ];

    binde = [
      # Brightness control
      ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
      ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
    ];
  };
}