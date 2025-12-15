{ pkgs, ...}:

{
  imports = [
    #./gnome.nix
    ./hyprland.nix
    #./plasma.nix
  ];

  # XServer
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Display Manager
  services.displayManager.gdm.enable = true;

  # Default session
  services.displayManager.defaultSession = "hyprland";

  # Enable screen sharing
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Disable Close/Minimize/Maximize buttons in GNOME
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/wm/preferences".button-layout = "''";
    }];
  };

  # System module for trash functionality
  services.gvfs.enable = true;

}