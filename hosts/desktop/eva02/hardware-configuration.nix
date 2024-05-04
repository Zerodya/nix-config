{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ce318a4c-470b-40dc-835e-f08505e601b5";
      fsType = "ext4";
    };

  # Encrypted root and swap
  boot.initrd.luks.devices."luks-460745e5-41a1-49d9-a67f-0d5bbcb46143".device = "/dev/disk/by-uuid/460745e5-41a1-49d9-a67f-0d5bbcb46143";
  boot.initrd.luks.devices."luks-9970f502-08f0-47a7-9a58-e88ec775dd98".device = "/dev/disk/by-uuid/9970f502-08f0-47a7-9a58-e88ec775dd98";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FBD3-7D47";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9ea55029-6687-4de9-8f9c-45c9c15a306e"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}