{ inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")

    ./security.nix
    ./users.nix
  ];

  # By default, the latest LTS linux kernel is installed

  # Delete old generations
  nix.gc = {
    automatic = true;
    dates = "03:00";
    options = "--delete-older-than 4d";
  };

  # Optimize Nix Store
  nix.optimise = {
    automatic = true;
    dates = [ "03:20" ];
  };

  # Automatic system upgrades
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs - `systemctl status nixos-upgrade.service`
    ];

    dates = "04:00";
    randomizedDelaySec = "10min";

    allowReboot = true;
    rebootWindow = {
      lower = "04:30";
      upper = "05:00";
    };
  };

}