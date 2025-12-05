{ inputs, username, pkgs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    app2unit
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;

    systemd.enable = true;

    settings = {
 
      appLauncher = {
        enableClipboardHistory = true;
        useApp2Unit = true;
        terminalCommand = "kitty -e";
        position = "bottom_center";
      };
  
      audio = {
        volumeOverdrive = true;
        visualizerType = "mirrored";
      };
  
      bar = {
        position = "left";
        density = "comfortable";
        showCapsule = false;
        backgroundOpacity = 1;
        capsuleOpacity = 1;
        exclusive = true;
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [];
        outerCorners = true;
  
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
              colorizeDistroLogo = false;
              customIconPath = "";
              icon = "noctalia";
            }
            {
              id = "Workspace";
              hideUnoccupied = false;
              followFocusedScreen = false;
              characterCount = 2;
              labelMode = "index";
            }
          ];
          center = [
            {
              id = "AudioVisualizer";
              colorName = "primary";
              hideWhenIdle = false;
              width = 200;
            }
            {
              id = "MediaMini";
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 145;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = false;
              showProgressRing = false;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
          ];
          right = [
            {
              id = "Tray";
              drawerEnabled = false;
              colorizeIcons = false;
              pinned = [];
              blacklist = [];
            }
            { id = "Brightness"; displayMode = "onhover"; }
            { id = "Volume"; displayMode = "onhover"; }
            { id = "Bluetooth"; displayMode = "onhover"; }
            { id = "WiFi"; displayMode = "onhover"; }
            {
              id = "Battery";
              displayMode = "onhover";
              deviceNativePath = "";
              warningThreshold = 30;
            }
            {
              id = "Clock";
              useCustomFont = false;
              customFont = "";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              usePrimaryColor = true;
            }
            {
              id = "SessionMenu";
              colorName = "error";
            }
          ];
        };
      };
  
      brightness = {
        enforceMinimum = false;
        enableDdcSupport = true;
      };
  
      calendar = {
        cards = [
          { enabled = true; id = "banner-card"; }
          { enabled = true; id = "calendar-card"; }
          { enabled = true; id = "timer-card"; }
          { enabled = true; id = "weather-card"; }
        ];
      };
  
      changelog = {
        lastSeenVersion = "";
      };
  
      colorSchemes = {
        useWallpaperColors = true;
        matugenSchemeType = "scheme-content";
        predefinedScheme = "Monochrome";
        generateTemplatesForPredefined = true;
        schedulingMode = "off";
        darkMode = true;
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
  
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "ScreenRecorder"; }
            { id = "WallpaperSelector"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
      };
  
      dock = {
        enabled = false;
      };
  
      general = {
        radiusRatio = 1;
        dimmerOpacity = 0.6;
        compactLockScreen = true;
        enableShadows = false;
      };
  
      hooks = {
        enabled = false;
        darkModeChange = "";
        wallpaperChange = "";
      };
  
      location = {
        name = "Naples, Italy";
        firstDayOfWeek = 1;
        use12hourFormat = true;
      };
  
      network = {
        wifiEnabled = false;
      };
  
      notifications = {
        location = "top_right";
      };
  
      osd = {
        location = "right";
        enabledTypes = [ 0 1 2 3 ];
      };
  
      sessionMenu = {
        position = "bottom_left";
        enableCountdown = true;
        countdownDuration = 10000;
        showHeader = true;
        powerOptions = [
          { action = "lock"; enabled = true; countdownEnabled = true; }
          { action = "suspend"; enabled = true; countdownEnabled = true; }
          { action = "hibernate"; enabled = false; countdownEnabled = true; }
          { action = "reboot"; enabled = true; countdownEnabled = true; }
          { action = "logout"; enabled = true; countdownEnabled = true; }
          { action = "shutdown"; enabled = true; countdownEnabled = true; }
        ];
      };
  
      systemMonitor = {
        networkPollingInterval = 5000;
        diskPollingInterval = 5000;
        tempPollingInterval = 5000;
        cpuPollingInterval = 5000;
        memPollingInterval = 5000;
      };
  
      templates = {
        enableUserTemplates = false;
      };
  
      ui = {
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
      };
  
      wallpaper = {
        panelPosition = "top_center";
        transitionType = "disc";
      };
    };
  };
}