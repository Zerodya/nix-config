{ config, pkgs, username, ... }:
let
  version = "v2.15.0";
  port = "8688";
  music-dir = "/mnt/storage/music";
  downloads-dir = "/mnt/storage/downloads";
in
{
  # IMPORTANT
  # You will have to connect Navidrome, Slskd, Last.fm etc. manually.
  # The url for internal services will be http://host.containers.internal:PORT and not http://127.0.0.1:PORT

  virtualisation.quadlet = {
    enable = true;
    containers.droppedneedle = {
      containerConfig = {
        image = "docker.io/droppedneedle/droppedneedle:${version}";
        publishPorts = [ "0.0.0.0:${port}:${port}" ];
        environments = {
          PUID = toString config.users.users.${username}.uid;
          UMASK = "002"; # group-writable, same as slskd
          PORT = port;
          TZ = config.time.timeZone;
          SLSKD_DOWNLOADS_PATH = "/data/downloads/complete";
        };
        # PGID = gid of the 'music' group, which NixOS allocates dynamically
        environmentFiles = [ "/run/droppedneedle.env" ];
        volumes = [
          # Named volumes, created by podman in /var/lib/containers (persisted)
          "droppedneedle-config:/app/config"
          "droppedneedle-cache:/app/cache"
          "droppedneedle-plugins:/app/plugins"
          # Library paths in the UI: /data/downloads/imported FIRST (import target), then /data/music.
          # The beets library is read-only here, beets-import moves albums into it.
          "${downloads-dir}:/data/downloads"
          "${music-dir}:/data/music:ro"
        ];
        dropCapabilities = [ "ALL" ];
        addCapabilities = [
          "CHOWN"  # entrypoint fixes ownership of /app/config and /app/cache
          "SETUID" # entrypoint drops from root to PUID/PGID
          "SETGID"
        ];
        noNewPrivileges = true;
      };
      serviceConfig = {
        ExecStartPre = pkgs.writeShellScript "droppedneedle-pgid" ''
          echo "PGID=$(${pkgs.getent}/bin/getent group music | ${pkgs.coreutils}/bin/cut -d: -f3)" > /run/droppedneedle.env
        '';
        Restart = "always";
      };
      unitConfig = {
        Description = "DroppedNeedle";
        After = [ "slskd.service" ];
      };
    };
  };
}
