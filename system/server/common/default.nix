{ pkgs, lib, inputs, modulesPath, ... }:

{
  imports = [
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

  # Podman - rootless Docker replacement
  virtualisation.containers.enable = true; # Enable common container config files in /etc/containers
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
  environment.systemPackages = with pkgs; [
    dive            # look into docker image layers
    podman-tui      # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose  # start group of containers for dev
  ];
}