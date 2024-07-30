{ pkgs, username, ... }:
{
  imports = [
    ./ags
    ./hyprland
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
      name = "Colloid-dark";
      package = pkgs.colloid-icon-theme;
    };
  };

  # Disable Stylix for KDE until it's fixed
  stylix.targets.kde.enable = false;

}