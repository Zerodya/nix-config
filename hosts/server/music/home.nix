{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;


  home.file."docker-compose/navidrome" = {
     source = ../../../home/docker-compose/navidrome;
     executable = true;
  };

  home.file."docker-compose/slskd" = {
     source = ../../../home/docker-compose/slskd;
     executable = true;
  };
  
}