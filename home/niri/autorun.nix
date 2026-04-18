{
   programs.niri.settings.spawn-at-startup = [
    # Shell
    { command = ["dms" "run"]; }

    # Daemons
    #{ command = ["wl-gammarelay-rs"]; }

    # Clipboard
    { command = ["wl-clip-persist" "--clipboard"]; }

    # Background apps
    { command = ["syncthing" "serve" "--no-browser"]; }
    { command = ["kdeconnectd"]; }
    { command = ["kdeconnect-indicator"]; }
    { command = ["pika-backup-monitor"]; }
  ];
}