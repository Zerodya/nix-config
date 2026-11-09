{
   programs.niri.settings.spawn-at-startup = [
    # Background apps
    { command = ["signal-desktop"]; }
    { command = ["sh" "-c" "sleep 10 && openrgb --startminimized --profile Green"]; }
    { command = ["steam" "-silent"]; }
    { command = ["easyeffects" "--service-mode"]; }
    { command = ["reaper" "-nosplash"]; }
    { command = ["flatpak" "run" "--command=bottles-cli" "com.usebottles.bottles" "run" "-b" "Music" "-p" "GuitarPro"]; }
    { command = ["qpwgraph" "--minimized"]; }
  ];
}