{ username, ... }:

{
  # Immich photos
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 4470;
    openFirewall = true;
    secretsFile = "/home/${username}/nix-config/hosts/server/photos/immich.env";
  };

  # Backup
  services.borgbackup = {
    jobs = {
      immich = {
        # What to back up
        paths = [ "/var/lib/immich" ];
        # Where to store the Borg repository
        repo = "/mnt/backups/immich";

        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /home/${username}/nix-config/hosts/server/photos/borg.key";
        };

        compression = "auto,zstd,9";

        removableDevice = true;

        # Keep 1 backup every 7 days
        startAt = "7d";
        prune.keep = { daily = 1; };
        persistentTimer = true;
      };
    };
  };

}