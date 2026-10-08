{ lib, pkgs, config, username, ...}:
let 
  music-dir = "/mnt/storage/music";
  # slskd -> downloads/complete -> droppedneedle verifies -> downloads/imported -> beets-import -> music-dir
  # Same filesystem as music-dir, so every step is an atomic move.
  downloads-dir = "/mnt/storage/downloads";
  beets-home = "/var/lib/beets/";
in 
{
  imports = [
    ./translate-lyrics.nix
    ./droppedneedle.nix
    ./beets-import.nix
  ];

  systemd.tmpfiles.rules = [
    # Permissions
    "d ${music-dir} 0770 ${username} music - -" # ensure the music directory exists and with correct permissions
    "a+ ${music-dir} - - - - d:g:music:rwx" # ensure music group can create directories in the music directory
    "a+ ${music-dir} - - - - f:g:music:rw" # ensure music group can write files in the music directory
    "d ${downloads-dir} 0770 ${username} music - -"
    "a+ ${downloads-dir} - - - - d:g:music:rwx" # slskd, droppedneedle and beets all move files through here
    "d ${downloads-dir}/complete 0770 slskd music - -"
    "d ${downloads-dir}/incomplete 0770 slskd music - -"
    "d ${downloads-dir}/imported 0770 ${username} music - -"

    # Beets config
    "L+ ${beets-home}.config/beets/config.yaml - beets music - ${./beets-config.yaml}"
    "L+ ${beets-home}.config/beets/genres.yaml - beets music - ${./beets-genres.yaml}"
    "L+ ${beets-home}.config/beets/whitelist.txt - beets music - ${./beets-whitelist.txt}"
  ];
  users.groups.music.members = [ "alpha" "navidrome" "slskd" "beets" "olivetin" ];

  # Ports
  networking.firewall = {
    allowedTCPPorts = [ 
      4533 # navidrome
      8688 # droppedneedle
      5030 # slskd
    ];
    allowedUDPPorts = [ 
      5030 # slskd
    ];
  };

  # ===== Navidrome =====
  services.navidrome = {
    enable = true;
    user = "navidrome";
    group = "music";

    settings = {
      Address = "0.0.0.0";
      Port = 4533;

      MusicFolder = "${music-dir}";
    };

    environmentFile = config.sops.templates."navidrome.env".path;
  };

  # ===== Slskd =====
  services.slskd = {
    enable = true;
    user = "slskd";
    group = "music";

    domain = "0.0.0.0";
    settings = {
      network.address = "0.0.0.0";
      network.port = 5030;

      directories.downloads = "${downloads-dir}/complete";
      directories.incomplete = "${downloads-dir}/incomplete";
      shares.directories = [ "${music-dir}" ];
    };

    environmentFile = config.sops.templates."slskd.env".path;
  };
  # The module's sandbox makes shares read-only and only the download dirs writable
  systemd.services.slskd.serviceConfig = {
    # Ensure downloaded files are writable by the 'music' group
    UMask = "002"; 
  };

  # ===== Beets =====
  environment.systemPackages = [ pkgs.beets ];
  # 'beets' user with access to the music directory. Usage: `sudo -u beets beet import /mnt/storage/music`
  users.users.beets = {
    isSystemUser = true;
    group = "music";
    home = "${beets-home}";
    createHome = true;
  };
}