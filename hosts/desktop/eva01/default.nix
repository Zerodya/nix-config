{ pkgs, desktop, config, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Desktop
      ../../../system/desktop/environment/default.nix

      # Modules
      ../../../system/modules/gaming.nix 
      ../../../system/modules/rt-audio.nix
      ../../../system/modules/ollama-rocm.nix
      #../../../system/modules/android-studio.nix
  ];

  networking.hostName = desktop;

  # Kernel
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
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

  # nix-cachyos-kernel binary cache
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
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
      libva-vdpau-driver
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

}