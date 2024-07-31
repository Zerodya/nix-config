{ ... }:
{
  imports = [
    ../../../system/server/common/home.nix
  ];


  home.file."docker-compose/streaming-stack" = {
     source = ../../../docker-compose/streaming-stack;
     executable = true;
  };

  home.file."docker-compose/torrent-stack" = {
     source = ../../../docker-compose/torrent-stack;
     executable = true;
  };
  
}