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
        natural-scroll = false;
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

      # Mirror laptop screen to the external display, press again to stop
      "Mod+Shift+M" = {
        action.spawn-sh = ''pkill -x wl-mirror || wl-mirror --fullscreen-output "$(niri msg -j outputs | jq -r 'keys[] | select(. != "eDP-1")' | head -n1)" eDP-1'';
        repeat = false;
        hotkey-overlay.title = "Mirror Display";
      };
    };

    # Keep keyboard focus on the slides, not the mirror
    window-rules = [
      {
        matches = [{ app-id = "^at\\.yrlf\\.wl_mirror$"; }];
        open-focused = false;
      }
    ];

    layout = {
      shadow = {
        enable = false;
      };
    };
  };
}