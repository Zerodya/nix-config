{ lib, pkgs, inputs, username, ... }:
let wallpapersDir = "/home/${username}/Pictures/Wallpapers"; in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "gtk3";
  };

  programs.caelestia = {
    enable = true;
    settings = {
      general = {
        apps = {
          terminal = "kitty";
          audio = "${pkgs.pwvucontrol}/bin/pwvucontrol";
        };
        idle = {
          # I manage idle and lock without caelestia
          lockBeforeSleep = false;
          inhibitWhenAudio = false;
          timeouts = [ ];
        };
      };
      bar = {
        status = {
          showAudio = true;
        };
        workspaces = {
          activeIndicator = true;
          activeLabel = "";
          activeTrail = true;
          label = "";
          occupiedBg = false;
          occupiedLabel = "";
          perMonitorWorkspaces = true;
          rounded = true;
          showWindows = true;
          shown = 6;
        };
        tray = {
          background = true;
        };
        entries = [
          { id = "logo"; enabled = false; }
          { id = "workspaces"; enabled = true; }
          { id = "spacer"; enabled = true; }
          { id = "activeWindow"; enabled = false; }
          { id = "spacer"; enabled = true; }
          { id = "tray"; enabled = true; }
          { id = "statusIcons"; enabled = true; }
          { id = "clock"; enabled = true; }
          { id = "idleInhibitor"; enabled = true; }
          { id = "power"; enabled = true; }
        ];
        clock = {
          showIcon = false;
        };
      };
      border = {
        rounding = 25;
        thickness = 10;
      };
      services = {
        useFahrenheit = false;
        weatherLocation = "40.9307, 14.2478";
        useTwelveHourClock = true;
        smartScheme = true;
        defaultPlayer = "Feishin";
      };
      launcher = {
        actionPrefix = ">";
      };
      lock = {
        enabled = false;
      };
      notifs = {
        actionOnClick = true;
        expire = true;
        defaultExpireTimeout = 8000;
      };
      paths = {
        wallpaperDir = wallpapersDir;
        sessionGif = " ";
        # mediaGif = "./assets/.gif";
      };
    };
    cli.enable = true;
  };

  wayland.windowManager.hyprland.settings.env = [
    "CAELESTIA_WALLPAPERS_DIR, ${wallpapersDir}"
  ];
}