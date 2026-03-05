{pkgs, ...}:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
        TZ="Europe/Rome";
      };
    };
  };

  # SteamDeck UI in Gamescope
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "steamdeck" ''
      #!/usr/bin/env bash
      pkill -9 -x steam
      pkill -9 -x gamescope-wl
      sleep 2

      exec env -u MANGOHUD STEAM_GAMESCOPE_VRR_SUPPORTED=1 \
        ${pkgs.gamescope}/bin/gamescope \
          --mangoapp \
          -W 2560 -H 1440 \
          -w 2560 -h 1440 \
          -r 165 \
          -O DP-1 \
          -e \
          --xwayland-count 2 \
          -- ${pkgs.steam.run}/bin/steam-run ${pkgs.steam}/bin/steam -steamdeck -steamos3
    '')
  ];

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
