{pkgs, ...}:

{
  chaotic = {
    mesa-git.enable = true;
    #hdr.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraLibraries = (pkgs: with pkgs; [
          gamemode
        ]);
      };
      gamescopeSession.enable = true;
      #remotePlay.openFirewall = true;
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
      };
    };

    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
      gpuOverclock.ppfeaturemask = "0xffffffff";
    };
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

      # BoilR
      "flathub:app/io.github.philipk.boilr//stable"
    ];
  };

}