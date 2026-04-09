{
  imports = [
    ./autorun.nix
  ];

  programs.niri.settings = {
    # Output configuration
    outputs."eDP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.01;
      };
    };
  
    # Input configuration
    input = {
      touchpad = {
        tap = true;
        accel-speed = 0.3;
        scroll-method = "edge";
      };
  
      trackpoint = {
        accel-speed = -0.6;
      };
    };
  
    binds = {
      # Brightness control
      "XF86MonBrightnessUp" = {
        action.spawn = [ "brightnessctl" "set" "5%+" ];
      };
      "XF86MonBrightnessDown" = {
        action.spawn = [ "brightnessctl" "set" "5%-" ];
      };
    };
  };
}