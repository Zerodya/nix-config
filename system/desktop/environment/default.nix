{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    #./plasma.nix
  ];

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  # Enable screen sharing
  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Disable Close/Minimize/Maximize buttons
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/wm/preferences".button-layout = "''";
    }];
  };

}