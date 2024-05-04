{ misc-server, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix
  ];

  networking.hostName = misc-server;

}