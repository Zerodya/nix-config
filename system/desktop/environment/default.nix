{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  # Enable screen sharing
  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
}