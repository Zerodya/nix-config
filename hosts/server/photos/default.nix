{ media-server, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix
  ];

  networking.hostName = media-server;

}