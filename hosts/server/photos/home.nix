{ ... }:
{
  imports = [
    ../../../system/server/common/home.nix
  ];


  home.file."docker-compose/immich-app" = {
     source = ../../../docker-compose/immich-app;
     executable = true;
  };
  
}