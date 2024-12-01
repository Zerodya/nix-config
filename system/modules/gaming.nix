{inputs, pkgs, ...}:

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


  environment.systemPackages = [ 
    inputs.umu.packages.${pkgs.system}.umu # UMU - Unified Proton launcher
  ];

  # OpenRGB
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
  };

  # Sunshine
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # Waydroid Android emulator
  virtualisation.waydroid.enable = true;
}