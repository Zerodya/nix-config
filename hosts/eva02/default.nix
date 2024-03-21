{ laptop, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Modules
      ../../system/modules/laptop.nix
  ];

  networking.hostName = laptop;
  
  # Wireless support via wpa_supplicant
  networking.wireless.enable = true; 

  # Firewall
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };
}