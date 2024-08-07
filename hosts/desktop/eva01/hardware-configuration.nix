{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/415ade6f-9049-4c24-8cf1-c15f2888f330";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/415ade6f-9049-4c24-8cf1-c15f2888f330";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };
  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/415ade6f-9049-4c24-8cf1-c15f2888f330";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4676-F685";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # Linux HDD Storage
  fileSystems."/mnt/linuxdisk" = {
    device = "UUID=fae6a6f8-30e1-4720-8f9e-03e1b10fff3c";
    fsType = "ext4";
    options = ["rw" "user" "exec"];
  };
  # Linux NVMe Storage
  fileSystems."/mnt/linuxdisk2" = {
    device = "UUID=0d15747d-6d76-4c5c-9639-50b680ce95fb";
    fsType = "ext4";
    options = ["rw" "user" "exec"];
  };
  # Windows NVMe Root
  fileSystems."/mnt/winroot" = {
    device = "UUID=20E6BB03E6BAD86C";
    fsType = "ntfs-3g";
    options = ["uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
  };
  # Windows HDD Storage
  fileSystems."/mnt/windisk" = {
    device = "UUID=54604BAA604B91A2";
    fsType = "ntfs-3g";
    options = ["uid=1000" "gid=1000" "rw" "user" "exec" "umask=000"];
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/848696e0-6850-4de9-9e0e-3f24d5a0483a"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
