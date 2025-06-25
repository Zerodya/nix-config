{ pkgs, username, ... }:
{
  imports = [
    ./fabric
    ./hyprland
    ./kitty
    ./programs
    ./quickshell
    ./scripts
    ./shell
    ./wallpapers
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;

  # Profile icon
  home.file.".face".source = ./.face;

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