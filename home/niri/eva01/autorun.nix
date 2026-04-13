{
   programs.niri.settings.spawn-at-startup = [
    # Background apps
    { command = ["signal-desktop"]; }
    { command = ["sleep 15" "&&" "openrgb" "--startminimized" "--profile" "white"]; }
    { command = ["steam" "-silent"]; }
    { command = ["easyeffect" "--service-mode"]; }
    { command = ["reaper" "-nosplash"]; }
    { command = ["qpwgraph" "--minimized"]; }
  ];
}