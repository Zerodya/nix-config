{pkgs, ...}:

let
  steamForGamescope = pkgs.steam.override {
    extraEnv = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-bin.steamcompattool}";
      STEAM_GAMESCOPE_VRR_SUPPORTED = "1";
    };
  };
in

{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
      };
    };
  };

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

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

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

  # Sunshine
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # Waydroid Android emulator
  virtualisation.waydroid.enable = true;

  services.flatpak = {
    packages = [
      # Gaming runtimes for Bottles
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope//24.08" # Gamescope
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud//24.08" # MangoHUD
      "flathub:runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt//24.08" # vkBasalt
    ];
  };

}
