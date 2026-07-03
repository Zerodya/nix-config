{ laptop, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Desktop
      ../../../system/desktop/environment/default.nix

      # Modules
      ../../../system/modules/gaming/default.nix
      ../../../system/modules/gaming/eva02.nix
      ../../../system/modules/laptop.nix
      ../../../system/modules/suspend-then-hibernate.nix
  ];

  networking.hostName = laptop;

  # Kernel
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot = {
    # CachyOS kernel is fine on Intel too — keep it
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    kernelParams = [ 
      "loglevel=3" 
      "quiet"
      "threadirqs" 
      "transparent_hugepage=always" 
      "split_lock_mitigate=0"
      # Disable power-saving features that hurt Intel iGPU performance
      "i915.enable_psr=0"
      "i915.enable_dc=0"
      "i915.enable_rc6=0"
      "pcie_aspm=off"
    ];
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ 
      "ntsync" 
    ]; 
    kernel.sysctl = { 
      "vm.swappiness" = 10; # Prefers ram over swap
      "vm.max_map_count" = 2147483642; # SteamOS default
    };
    blacklistedKernelModules = [ "tdx" ];
  };

  # sched_ext kernel scheduler
  services.scx = { 
    enable = true;
    scheduler = "scx_lavd";
  };

  # nix-cachyos-kernel binary cache
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  # Graphics
  hardware.graphics = {
    enable = true; # Mesa
    enable32Bit = true; #32-bit graphics support (for Steam)
    extraPackages = with pkgs; [ 
      # Video Acceleration API
      libva-vdpau-driver
    ];
  };
  services.xserver.videoDrivers = [ "modesetting" ];

  # Environment
  environment.variables = {
    MESA_SHADER_CACHE_MAX_SIZE = "2G";
    WINEPREFIX = "/home/alpha/.wine";
  };

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