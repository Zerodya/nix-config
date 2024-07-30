{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;


  home.file."docker-compose/homepage" = {
     source = ../../../docker-compose/homepage;
     executable = true;
  };

  home.file."docker-compose/pihole" = {
     source = ../../../docker-compose/pihole;
     executable = true;
  };
  
}