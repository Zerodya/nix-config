{ pkgs, recovery-iso, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "${recovery-iso}";
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

  # The installer's NetworkManager gets an IP via DHCP; announce it as ritsuko.local so it's found on any network and NIC
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
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
  isoImage.volumeID = "NIXOS_RITSUKO_RECOVERY";

  system.stateVersion = "24.11";
}