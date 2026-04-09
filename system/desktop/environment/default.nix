{
  imports = [
    #./gnome.nix
    #./hyprland.nix
    ./niri.nix
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
  services.displayManager.defaultSession = "niri";

  # Portal
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

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