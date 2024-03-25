{ username, ... }:
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
}
