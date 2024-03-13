{ username, ... }:
{
  imports = [
    ./ags
    ./hyprland
    ./modules
    ./programs
    ./shell
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
