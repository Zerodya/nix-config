{ pkgs, lib, ... }:

{
  # Packages
  home.packages = with pkgs; [
    # Clipboard
    wl-clip-persist
    wl-clipboard
    xclip
    clipnotify
    
    # Utilities
    wl-gammarelay-rs
    
    # Idle daemon
    swayidle
  ];

  imports = [
    ./autorun.nix
    ./swayidle.nix
  ];

  programs.niri.settings = {
    hotkey-overlay.skip-at-startup = true;
    prefer-no-csd = true;
    
    # XWayland
    xwayland-satellite = {
      enable = true;
      path = lib.getExe pkgs.xwayland-satellite-unstable;
    };

    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "us,it,us";
          variant = ",,colemak_dh_iso";
        };
        numlock = true;
      };
      
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
    };
    
    # Layout
    layout = {
      gaps = 12;
      center-focused-column = "on-overflow";
      always-center-single-column = true;
      
      preset-column-widths = [
        { proportion = 0.49; }
        { proportion = 0.98; }
      ];
      
      default-column-width = { proportion = 0.49; };
      
      focus-ring = {
        enable = true;
        width = 2;
      };
      
      border = {
        enable = false;
      };
      
      shadow = {
        enable = false;
      };
    };
    
    # Animations
    animations = {
      window-open = {
        kind.easing = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
      };
      
      window-close = {
        kind.easing = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
      };
      
      horizontal-view-movement = {
        kind.spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
      };
      
      workspace-switch = {
        kind.spring = {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };
      };
    };

    # Persistent workspaces
    workspaces = {
      "1" = {};
      "2" = {};
      "3" = {};
      "4" = {};
      "5" = {};
      "6" = {};
    };
    
    # Window rules
    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 20.0;
          top-right = 20.0;
          bottom-left = 20.0;
          bottom-right = 20.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [ { app-id = "REAPER"; } ];
        open-on-workspace = "6";
      }
      {
        matches = [ { app-id = "^steam$"; } ];
        excludes = [ { title = "^Steam$"; } ];
        open-floating = true;
      }
    ];
    
    # Overview
    layer-rules = [
      {
        matches = [ { namespace="^quickshell$"; } ];
        place-within-backdrop = true;
      }
    ];
    layout = {
      background-color = "transparent";
    };
    overview.workspace-shadow.enable = false;
    
    # Key bindings
    binds = {
      # Spawn software
      "Mod+Return" = {
        action.spawn = "kitty";
        hotkey-overlay.title = "Open Terminal";
      };
      "Mod+S" = {
        action.spawn = "nautilus";
        hotkey-overlay.title = "Open Files";
      };
      "Mod+P" = {
        action.spawn = "solanum";
        hotkey-overlay.title = "Pomodoro";
      };
      "Mod+O" = {
        action.spawn = "blanket";
        hotkey-overlay.title = "Ambient Sounds";
      };
      "Mod+F12" = {
        action.spawn = "steamos";
        hotkey-overlay.title = "SteamDeck Mode";
      };

      # Shell IPC
      "Mod+D" = {
        action.spawn = [ "dms" "ipc" "launcher" "toggle"];
        hotkey-overlay.title = "Toggle Launcher";
      };
      "Mod+E" = {
        action.spawn = [ "dms" "ipc" "powermenu" "toggle" ];
        hotkey-overlay.title = "Toggle Session";
      };
      "Mod+Shift+C" = {
        action.spawn = [ "dms" "ipc" "clipboard" "toggle" ];
        hotkey-overlay.title = "Toggle Clipboard";
      };
      
      # Window operations
      "Mod+Q" = {
        action.close-window = {};
        repeat = false;
        hotkey-overlay.title = "Close Window";
      };
      "Mod+X" = {
        action.toggle-window-floating = {};
        hotkey-overlay.title = "Toggle Floating";
      };
      "Mod+F" = {
        action.maximize-column = {};
        hotkey-overlay.title = "Maximize";
      };
      "Mod+Shift+F" = {
        action.fullscreen-window = {};
        hotkey-overlay.title = "Fullscreen";
      };

      # Overview
      "Mod+backspace" = { 
        action.toggle-overview = {};
        repeat = false;
      };

      # Cycle windows
      "Alt+Tab" = { action.focus-window-down-or-column-right = {}; };
      "Alt+Shift+Tab" = { action.focus-window-up-or-column-left = {}; };
      
      # Column operations
      "Mod+Z" = { action.focus-column-right = {}; };
      "Mod+less" = { action.focus-column-left = {}; };
      "Mod+Shift+Z" = { action.move-column-right = {}; };
      "Mod+Shift+less" = { action.move-column-left = {}; };
      "Mod+WheelScrollDown" = { action.focus-column-right = {}; };
      "Mod+WheelScrollUp" = { action.focus-column-left = {}; };
      "Mod+C" = { action.switch-preset-column-width = {}; };
      "Mod+T" = { action.switch-preset-window-height = {}; };
      
      # Switch workspaces with Mod + [0-6]
      "Mod+1" = { action.focus-workspace = 1; };
      "Mod+2" = { action.focus-workspace = 2; };
      "Mod+3" = { action.focus-workspace = 3; };
      "Mod+4" = { action.focus-workspace = 4; };
      "Mod+5" = { action.focus-workspace = 5; };
      "Mod+6" = { action.focus-workspace = 6; };
      
      # Move active window to a workspace with Mod + Shift + [0-6]
      "Mod+Shift+1" = { action.move-column-to-workspace = 1; };
      "Mod+Shift+2" = { action.move-column-to-workspace = 2; };
      "Mod+Shift+3" = { action.move-column-to-workspace = 3; };
      "Mod+Shift+4" = { action.move-column-to-workspace = 4; };
      "Mod+Shift+5" = { action.move-column-to-workspace = 5; };
      "Mod+Shift+6" = { action.move-column-to-workspace = 6; };
      
      # Workspace back and forth
      "Mod+Tab" = { action.focus-workspace-previous = {}; };
      
      # Audio/Mic control
      "XF86AudioRaiseVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" ];
      };
      "XF86AudioLowerVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
      };
      "XF86AudioMute" = {
        action.spawn = [ "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle" ];
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action.spawn = [ "pactl" "set-source-mute" "@DEFAULT_SOURCE@" "toggle" ];
        allow-when-locked = true;
      };

      # Media control
      "XF86AudioPlay" = {
        action.spawn = [ "playerctl" "play-pause" ];
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action.spawn = [ "playerctl" "next" ];
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action.spawn = [ "playerctl" "previous" ];
        allow-when-locked = true;
      };
      
      # Screenshots
      "Print".action.screenshot-screen = [];
      "Mod+Print".action.screenshot = {};
      
      # Quit / Suspend / Turn off screen
      "Mod+Shift+E" = {
        action.quit = {};
        hotkey-overlay.title = "Exit Niri";
      };
      "Mod+Escape" = {
        action.spawn-sh = "systemctl suspend";
        hotkey-overlay.title = "Lock & Suspend";
      };
      "Mod+Shift+Escape" = {
        action.spawn-sh = "sleep 1 && niri msg action power-off-monitors";
        hotkey-overlay.title = "Screen Off";
      };
      
      # Switch 
      "Mod+Space" = {
        action.spawn = [ "niri" "msg" "action" "switch-layout" "next" ];
      };
    };

    # Events
    switch-events = {
      lid-close = {
        action.spawn = [ "sleep" "10" "&&" "systemctl" "suspend" ];
      };
    };
  };
}