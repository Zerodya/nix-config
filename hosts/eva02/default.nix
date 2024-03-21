{ laptop, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Modules
      ../../system/modules/laptop.nix
      ../../system/modules/suspend-then-hibernate.nix
  ];

  networking.hostName = laptop;

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