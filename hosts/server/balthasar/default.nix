{ optiplex, ... }:

let
  lan = import ../../lan.nix;
in
{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix

      # Modules
      ../../../system/modules/vm-lab.nix
  ];

  networking.hostName = optiplex;

  networking = {
    useDHCP = false;
    networkmanager.enable = false;

    interfaces.eno1 = {
      ipv4.addresses = [{
        address = lan.balthasar;
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = lan.gateway;
      interface = "eno1";
    };
  };

  # GOAD-Light, its VirtualBox sizing: 12GB of 16GB
  vmLab = {
    internet = false; # true while GOAD provisions Windows, rebuild to toggle
    autostart = false; # true once provisioned, so powering on brings the lab up
    windowsVms = {
      kingslanding = 3; # DC01
      winterfell = 3; # DC02
      castelblack = 6; # SRV02, IIS and MSSQL
    };
  };

  # Three near-identical Windows VMs share most of their memory pages
  hardware.ksm.enable = true;
  zramSwap.enable = true; # headroom without swapping to the HDD
}
