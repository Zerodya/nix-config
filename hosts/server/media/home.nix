{ username, ... }:
{
  imports = [
    ../../../home/docker-compose/streaming-stack
    ../../../home/docker-compose/torrent-stack
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

}