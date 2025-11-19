{
  imports = [
    #./gnome.nix
    ./hyprland.nix
    #./plasma.nix
  ];

  # Display Manager
  services.displayManager.gdm.enable = true;

  # Default session
  services.displayManager.defaultSession = "hyprland";

  # Enable screen sharing
  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Disable Close/Minimize/Maximize buttons in GNOME
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/wm/preferences".button-layout = "''";
    }];
  };

  # Wayland for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # System module for trash functionality
  services.gvfs.enable = true;

}