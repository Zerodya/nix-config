{ thinkcentre, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix

      # Sops-nix
      ./sops.nix

      # Cloudflare
      ./cloudflare.nix

      # Modules
      #./minecraft/default.nix
      ./music/default.nix
      #./photos/default.nix
  ];

  networking.hostName = thinkcentre;

  networking = {
    useDHCP = false;
    networkmanager.enable = false;

    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.201";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };
  };

}