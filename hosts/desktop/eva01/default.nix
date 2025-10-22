{ pkgs, desktop, config, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Desktop
      ../../../system/desktop/environment/default.nix

      # Modules
      ../../../system/modules/gaming.nix 
      ../../../system/modules/rt-audio.nix
      #../../../system/modules/ollama-rocm.nix
  ];

  networking.hostName = desktop;

  # Bootloader
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_cachyos;
    extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
    kernelParams = [ 
      "loglevel=3" 
      "quiet"
      "amd_pstate=passive"
      "initcall_blacklist=acpi_cpufreq_init"
      "threadirqs" 
      "transparent_hugepage=always" 
      "split_lock_mitigate=0"
    ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ 
      "zenpower" 
      "cpufreq_ondemand" 
      "cpufreq_conservative" 
      "cpufreq_powersave"
      "ntsync"
    ];
    kernel.sysctl = { 
      "vm.swappiness" = 10; # Prefers ram over swap
      "vm.max_map_count" = 2147483642; # SteamOS default
    };
  };
  
  # sched_ext kernel scheduler
  services.scx = { 
    enable = true;
    scheduler = "scx_lavd";
  };

  # Hardware
  hardware.graphics = {
    enable = true; # Mesa
    enable32Bit = true; #32-bit graphics support (for Steam)
    extraPackages = with pkgs; [ 
      # Video Acceleration API
      vaapiVdpau
      #libvdpau-va-gl
    ];
  };
  hardware.i2c.enable = true;

  # GPU options
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "False"
      Option "VariableRefresh" "True"
    '';
  };

  # Environment
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
    WINEPREFIX = "/home/alpha/.wine";
  };

  # Firewall
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 
      47984 47989 48010 # Sunshine 
    ];
    allowedUDPPorts = [ 
      5353 47998 47999 48000 48002 48010 # Sunshine 
    ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };

  # Btrfs 
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Stylix Color Scheme
  stylix = {
    image = ../../../home/wallpapers/persona3.png;
    polarity = "dark";

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
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
  };

}