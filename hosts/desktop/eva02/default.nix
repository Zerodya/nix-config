{ laptop, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Desktop
      ../../../system/desktop/environment/default.nix

      # Modules
      ../../../system/modules/laptop.nix
      ../../../system/modules/suspend-then-hibernate.nix
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

  stylix = {
    image = ../../../home/wallpapers/2.png;
    polarity = "light";

    base16Scheme ={ # carbonfox theme
      base00 = "161616";
      base01 = "252525";
      base02 = "353535";
      base03 = "484848";
      base04 = "7b7c7e";
      base05 = "f2f4f8";
      base06 = "b6b8bb";
      base07 = "e4e4e5";
      base08 = "ee5396";
      base09 = "3ddbd9";
      base0A = "08bdba";
      base0B = "25be6a";
      base0C = "33b1ff";
      base0D = "78a9ff";
      base0E = "be95ff";
      base0F = "ff7eb6";
    };
  };
  
}