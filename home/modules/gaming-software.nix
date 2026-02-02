{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Launcher
    umu-launcher
    steam-rom-manager

    # Game utilities
    gamescope
    vkbasalt
    mangohud
    lsfg-vk
    lsfg-vk-ui
    goverlay

    # Wine/Proton
    winetricks
    protontricks
    protonplus

    # DirectX
    directx-headers

    # Vulkan / OpenGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    clinfo

    # Emulators
    ryubing
    #rpcs3

    # Steering Wheel
    oversteer

    # Native Games
    osu-lazer-bin
  ];
  
}