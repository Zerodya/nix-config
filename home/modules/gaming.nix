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

}