{ pkgs, lib, inputs, modulesPath, ... }:

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

  # --- Proxmox LXC stuff below ---

  # Supress systemd units that don't work because of LXC
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  # start tty0 on serial console
  systemd.services."getty@tty1" = {
    enable = lib.mkForce true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
  };

}