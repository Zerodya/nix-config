{ pkgs, username, ... }:
{
  imports = [
    ./ags
    ./fabric
    ./hyprland
    ./kitty
    ./programs
    ./scripts
    ./shell
    ./swaylock
    ./wallpapers
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;

  # GTK
  gtk = {
    enable = true;

    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };

  # Disable Stylix for KDE until it's fixed
  stylix.targets.kde.enable = false;

}