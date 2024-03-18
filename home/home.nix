{ username, ... }:
{
  imports = [
    ./ags
    ./hyprland
    ./programs
    ./shell
    ./scripts
    ./wallpapers
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
