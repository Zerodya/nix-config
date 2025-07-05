{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Launcher
    umu-launcher
    steam-rom-manager

    # Game utilities
    gamescope
    vkbasalt
    mangohud

    # Wine/Proton
    winetricks
    protontricks
    protonup-qt

    # DirectX
    directx-headers

    # Vulkan / OpenGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    clinfo

    # Emulators
    ryujinx
    #rpcs3

    # Steering Wheel
    oversteer

    # Native Games
    osu-lazer-bin
  ];
  
}