{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = { 
	    device = "/dev/disk/by-uuid/e55bdb6d-87ab-43d3-846b-bddb9543874f";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };
    "/home" = { 
	    device = "/dev/disk/by-uuid/e55bdb6d-87ab-43d3-846b-bddb9543874f";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime"];
    };
    "/nix" = { 
	    device = "/dev/disk/by-uuid/e55bdb6d-87ab-43d3-846b-bddb9543874f";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/E222-00B2";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    # HDD Storage
    "/mnt/linuxdisk" = {
      device = "UUID=44e72c54-af38-4edc-b516-6fecaddc0812";
      fsType = "ext4";
      options = [ "nofail" "rw" "user" "exec" ];
    };
    # SSD Storage
    "/mnt/linuxdisk2" = {
      device = "UUID=ae6a2fec-b0e3-4c0c-9684-dffbdf854fb1";
      fsType = "btrfs";
      options = [ "nofail" "rw" "user" "exec" "compress=zstd" "noatime" ];
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/dbd48f80-222e-4d3f-af90-b06f5cad8357"; }
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
