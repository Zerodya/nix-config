{  lib, username, config, ... }:

{
  # Use password saved in sops secret
  users.users.${username}.hashedPasswordFile = config.sops.secrets.server-password.path;
  users.mutableUsers = false;

  # Rollback root to blank snapshot on boot
  boot.initrd = {
    enable = true;
    supportedFilesystems = [ "btrfs" ];

    postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-uuid/2c1aa9ba-ada3-46f8-bb1d-0471c5af2ec9 /btrfs_tmp
    
    if [[ -e /btrfs_tmp/root ]]; then
      btrfs subvolume list -o /btrfs_tmp/root | cut -f9 -d' ' | while read subvolume; do
        btrfs subvolume delete "/btrfs_tmp/$subvolume"
      done
      
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi
  
    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }
  
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done
  
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
'';
  };
  
  # Persist state
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    
    # System directories
    directories = [
      # Logs
      "/var/log"

      # System state
      "/var/lib/nixos"

      # Services data
      "/var/lib/navidrome"
      "/var/lib/slskd"
      "/var/lib/beets"
    ];
    files = [
      # Sops key
      "/var/lib/sops-nix/keys.txt"

      # SSH keys
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    
    # Home directories
    users.alpha = {
      directories = [
        # Fish history
        ".local/share/fish/"

        # Cloudflare credentials
        { directory = ".cloudflared"; mode = "0700"; }

        # Sops keys
        { directory = ".config/sops/age"; mode = "0600"; }
      ];
      files = [

      ];
    };
  };

  # Ensure SSH host keys have correct permissions after restoration
  systemd.tmpfiles.rules = [
    "d /etc/ssh 0755 root root -"
    "z /etc/ssh/ssh_host_* 0600 root root -"
  ];

  # Disable sudo lecture since it gets reset
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}