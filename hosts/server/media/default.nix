{ media-server, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/desktop/environment/default.nix
  ];

  networking.hostName = media-server;

}