{ ... }:
{
  imports = [
    ../../../system/server/common/home.nix
  ];


  home.file."docker-compose/homepage" = {
     source = ../../../docker-compose/homepage;
     executable = true;
  };

  home.file."docker-compose/pihole" = {
     source = ../../../docker-compose/pihole;
     executable = true;
  };
  
}