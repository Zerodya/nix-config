{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "maya";
  time.timeZone = "Europe/Rome";

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Authorized SSH keys
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7tSjPE3l7mcQsWNXx3Df5w3Kr840XQBAWdISUSuVRh alpha@eva01" # My desktop
  ];

  # Static IP so you know where to find it
  networking = {
    useDHCP = false;

    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.250"; # Static IP
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eno1";
    };

    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # Essential tools for recovery
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nix-diff
    btrfs-progs
    cryptsetup
    parted
    gptfdisk
    rsync
    sshfs
    btop
    nvme-cli
    smartmontools
    dosfstools
    e2fsprogs
    util-linux
    vim
    git
  ];

  # Fish functions
  users.users.root.shell = pkgs.fish;
  programs.fish.enable = true;
  programs.fish.shellAliases = {
   "," = "nix-shell -p";
  };

  # ISO image settings
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.volumeID = "NIXOS_MAYA_RECOVERY";

  system.stateVersion = "24.11";
}