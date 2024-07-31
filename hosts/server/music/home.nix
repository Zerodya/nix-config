{ ... }:
{
  imports = [
    ../../../system/server/common/home.nix
  ];


  home.file."docker-compose/navidrome" = {
     source = ../../../docker-compose/navidrome;
     executable = true;
  };

  home.file."docker-compose/slskd" = {
     source = ../../../docker-compose/slskd;
     executable = true;
  };
  
}