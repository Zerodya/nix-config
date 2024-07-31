{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;


  home.file."docker-compose/immich-app" = {
     source = ../../../docker-compose/immich-app;
     executable = true;
  };
  
}