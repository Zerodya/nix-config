{ pkgs, username, ... }:
{
  imports = [
    # Core
    ./firefox
    ./kitty
    ./programs
    ./scripts
    ./shell

    # Environment
    ./caelestia-shell
    ./hyprland
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

}