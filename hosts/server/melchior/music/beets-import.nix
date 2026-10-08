{ pkgs, ... }:
let
  music-dir = "/mnt/storage/music";
  imported-dir = "/mnt/storage/downloads/imported"; # where droppedneedle puts verified albums
  beets-home = "/var/lib/beets";
in
{
  # Moves albums verified by droppedneedle into the library, tagged and renamed by beets.
  # Logs: `journalctl -u beets-import`
  systemd.services.beets-import = {
    description = "Import downloaded albums with beets";
    path = [ pkgs.beets "/run/current-system/sw" ]; # beets 'hook' plugin calls translate-lyrics
    script = ''
      stamp=${beets-home}/.import-stamp
      [ -e "$stamp" ] || touch -d @0 "$stamp"

      # Nothing arrived since the last run (moving a file in bumps its ctime)
      [ -n "$(find ${imported-dir} -type f -cnewer "$stamp" -print -quit)" ] || exit 0
      # droppedneedle is still moving an album in, wait for the next run
      [ -z "$(find ${imported-dir} -type f -cmin -1 -print -quit)" ] || exit 0

      start=$(date +%s)
      # -q: no prompts, uncertain matches fall back to 'asis' (see beets-config.yaml)
      # -I: re-downloads of a path beets already saw must not be skipped
      beet import -q -I ${imported-dir}
      # Only after success, so a failed import is retried on the next run
      touch -d "@$start" "$stamp"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "beets";
      Group = "music";
      UMask = "002";
      
      SyslogLevel = "notice";
      LogLevelMax = "notice";
      ProtectSystem = "strict";
      ReadWritePaths = [ music-dir imported-dir beets-home ];
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      NoNewPrivileges = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
    };
  };

  systemd.timers.beets-import = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = "minutely";
  };
}
