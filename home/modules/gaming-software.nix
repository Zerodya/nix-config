{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Launcher
    umu-launcher
    steam-rom-manager

    # Game utilities
    vkbasalt
    mangohud
    lsfg-vk
    lsfg-vk-ui
    goverlay
    deadlock-mod-manager

    # Wine/Proton
    winetricks
    protonplus

    # Vulkan
    vulkan-loader
    vulkan-tools

    # Emulators
    ryubing
    #rpcs3

    # Hardware
    oversteer
    sc-controller

    # Native Games
    osu-lazer-bin
  ];
  
}