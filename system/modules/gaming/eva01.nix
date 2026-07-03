{ pkgs, jovian, username, lib, config, ... }:
let
  steamForGamescope = pkgs.steam.override {
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
        ${pkgs.steam}/bin/steam -shutdown
        
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
          -W 2560 -H 1440 \
          -w 2560 -h 1440 \
          -r 165 \
          -O DP-1 \
          -f \
          -e \
          --rt \
          --mangoapp \
          --adaptive-sync \
          --force-grab-cursor \
          --xwayland-count 2 \
          -- ${steamForGamescope}/bin/steam -steamdeck -steamos3
    '')
  ];

  # Decky Loader
  jovian = {
    decky-loader.enable = true;
    decky-loader.user = "${username}";
    steam.user = "${username}";
  };
  # Create Steam CEF debugging file if it doesn't exist for Decky Loader
  systemd.services.steam-cef-debug = lib.mkIf config.jovian.decky-loader.enable {
    description = "Create Steam CEF debugging file";
    serviceConfig = {
      Type = "oneshot";
      User = config.jovian.steam.user;
      ExecStart = "/bin/sh -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Sunshine
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # Waydroid Android emulator
  virtualisation.waydroid.enable = true;

  # LACT
  services.lact.enable = true;
  hardware.amdgpu.overdrive = {
    enable = true;
    ppfeaturemask = "0xffffffff";
  };

  # OpenRGB
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd";
  };
}