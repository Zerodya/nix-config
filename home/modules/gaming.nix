{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Launcher
    bottles
    cartridges

    # Game utilities
    gamescope
    vkbasalt
    mangohud

    # Wine/Proton
    wineWowPackages.stagingFull
    winetricks
    protontricks
    protonup-qt

    # DirectX
    dxvk
    vkd3d-proton
    directx-headers

    # Vulkan / OpenGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    clinfo

    # Emulators
    ryujinx
    #rpcs3

    # Mouse
    piper
    libratbag

    # Streaming
    sunshine

    # RGB
    openrgb-with-all-plugins
  ];
}