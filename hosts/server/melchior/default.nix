{ thinkcentre, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix

      # Secrets
      ./secrets.nix

      # Modules
      #./minecraft/default.nix
      ./music/default.nix
      #./photos/default.nix
  ];

  networking.hostName = thinkcentre;

  networking = {
    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.130";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
  };

}