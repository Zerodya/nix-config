{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;


  home.file."docker-compose/streaming-stack" = {
     source = ../../../docker-compose/streaming-stack;
     executable = true;
  };

  home.file."docker-compose/torrent-stack" = {
     source = ../../../docker-compose/torrent-stack;
     executable = true;
  };
  
}