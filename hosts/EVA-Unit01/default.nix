{ pkgs, desktop, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Modules
      ../../system/modules/gaming.nix 
      ../../system/modules/rt-audio.nix
  ];

  networking.hostName = desktop;

  # Mountpoints
  fileSystems."/home" = {
    device = "UUID=a3a950b3-bf55-45b6-8ea2-9d0215de99a1";
    fsType = "ext4";
  };
  fileSystems."none" = {
    device = "UUID=848696e0-6850-4de9-9e0e-3f24d5a0483a";
    fsType = "swap";
  };
  fileSystems."/mnt/linuxdisk" = {
    device = "UUID=fae6a6f8-30e1-4720-8f9e-03e1b10fff3c";
    fsType = "ext4";
    options = ["rw" "user" "exec"];
  };
  fileSystems."/mnt/linuxdisk2" = {
    device = "UUID=0d15747d-6d76-4c5c-9639-50b680ce95fb";
    fsType = "ext4";
    options = ["rw" "user" "exec"];
  };
  fileSystems."/mnt/winroot" = {
    device = "UUID=20E6BB03E6BAD86C";
    fsType = "ntfs-3g";
    options = ["uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
  };
  fileSystems."/mnt/windisk" = {
    device = "UUID=54604BAA604B91A2";
    fsType = "ntfs-3g";
    options = ["uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
  };

  # Bootloader
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
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

  # Nix Store
  nix.optimise = {
    automatic = true;
    dates = [ "12:00" ];
  };
  nix.gc = {
    automatic = true;
    dates = "12:00";
    options = "--delete-older-than 7d";
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