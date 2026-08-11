{ pkgs, ... }:
let
  steamForGamescope = pkgs.millennium-steam.override {
    extraEnv = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-bin.steamcompattool}";
      STEAM_GAMESCOPE_VRR_SUPPORTED = "1";
    };
  };
in
{
  # SteamDeck UI in Gamescope
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "steamos" ''
      #!/usr/bin/env bash

      if pgrep -x steam > /dev/null; then
        ${pkgs.millennium-steam}/bin/steam -shutdown
        
        for i in {1..10}; do
          if ! pgrep -x steam > /dev/null; then
            break
          fi
          sleep 1
        done

        if pgrep -x steam > /dev/null; then
          pkill -9 -x steam
          pkill -9 -x gamescope-wl
          sleep 1
        fi
      fi

      exec ${pkgs.gamescope}/bin/gamescope \
          -W 1920 -H 1080 \
          -w 1920 -h 1080 \
          -r 60 \
          -O DP-1 \
          -f \
          -e \
          --rt \
          --mangoapp \
          --force-grab-cursor \
          --xwayland-count 2 \
          -- ${steamForGamescope}/bin/steam -steamdeck -steamos3
    '')
  ];
}