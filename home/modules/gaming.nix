{inputs, config, pkgs, ...}: {
  home.packages = with pkgs; [
    # Launcher
    bottles
    cartridges

    # Wine/Proton
    winetricks
    protontricks
    protonup-qt
    
    # Emulators
    ryujinx
    rpcs3

    # Streaming
    sunshine

    # RGB
    openrgb-with-all-plugins
  ];

  # Programs
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = (pkgs: with pkgs; [
        gamemode
      ]);
    };
    gamescopeSession.enable = true;
    #remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;
  
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
    gpuOverclock.ppfeaturemask = "0xffffffff";
  };

}