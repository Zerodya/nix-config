{ pkgs, desktop, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Modules
      ../../system/modules/gaming.nix 
      ../../system/modules/rt-audio.nix
  ];

  networking.hostName = desktop;

  # Bootloader
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [ 
      "loglevel=3" 
      "quiet"
      "amd_pstate=passive"
      "initcall_blacklist=acpi_cpufreq_init"
      "threadirqs" 
      "transparent_hugepage=always" 
    ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ 
      "amd-pstate" 
      "cpufreq_ondemand" 
      "cpufreq_conservative" 
      "cpufreq_powersave" 
      "i2c-dev" 
      "i2c-piix4" 
    ];
    kernel.sysctl = { 
      "vm.swappiness" = 10; # Prefers ram over swap
      "vm.max_map_count" = 2147483642; # SteamOS default
    };
  };

  # Hardware
  hardware.opengl = {
    enable = true; # Mesa
    driSupport32Bit = true; # Steam support
    extraPackages = with pkgs; [ 
      # OpenCL
      rocmPackages.clr.icd 
      # OpenGL and Vulkan
      rocm-opencl-icd 
      rocm-opencl-runtime
      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
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
    PATH = "$HOME/git/path/hyprfreeze:$HOME/git/path/hyprprop:$HOME/git/path/hyprevents"; 
    AMD_VULKAN_ICD = "RADV";
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

}