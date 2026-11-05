{ config, ... }:
let
  # 3.6.4, keep aligned with the navidrome plugin (nixpkgs navidromePlugins.audiomuseai)
  digest = "sha256:811f1f0bd0de97a1b4ab6601898297010da18fc957312b1ed3bb62990683630c";
  port = "8000";
  inherit (config.virtualisation.quadlet) pods;
  envFile = config.sops.templates."audiomuse.env".path;

  # Flask (web UI + API) and worker (audio analysis) share the same image and settings
  app = type: {
    containerConfig = {
      pod = pods.audiomuse.ref;
      image = "ghcr.io/neptunehub/audiomuse-ai@${digest}";
      environments = {
        SERVICE_TYPE = type;
        MEDIASERVER_TYPE = "navidrome";
        TZ = config.time.timeZone;
        POSTGRES_USER = "audiomuse";
        POSTGRES_DB = "audiomusedb";
        POSTGRES_HOST = "localhost"; # same pod
        POSTGRES_PORT = "5432";
        TEMP_DIR = "/app/temp_audio";
      };
      environmentFiles = [ envFile ]; # POSTGRES_PASSWORD
      tmpfses = [ "/app/temp_audio" ];
      volumes = [ "audiomuse-plugins-${type}:/app/plugin/installed" ];
      # Audio is streamed from navidrome's API, no access to the music dir needed
      dropCapabilities = [ "ALL" ];
      noNewPrivileges = true;
    };
    unitConfig = {
      Description = "AudioMuse-AI ${type}";
      After = [ "audiomuse-postgres.service" ];
      Requires = [ "audiomuse-postgres.service" ];
    };
    serviceConfig.Restart = "always";
  };
in
{
  # IMPORTANT
  # First visit http://melchior:8000 opens the Setup Wizard: pick Navidrome, URL http://host.containers.internal:4533,
  # set the AudioMuse login and an API token, then run a first analysis.
  # Then in Navidrome: Settings > Plugins > AudioMuse-AI, API URL http://127.0.0.1:8000 and the same API token.

  virtualisation.quadlet = {
    enable = true;
    pods.audiomuse = {
      podConfig.publishPorts = [ "0.0.0.0:${port}:${port}" ];
      autoStart = true;
    };
    containers = {
      audiomuse-flask = app "flask";
      audiomuse-worker = app "worker";
      audiomuse-postgres = {
        containerConfig = {
          pod = pods.audiomuse.ref;
          image = "docker.io/library/postgres@sha256:54e0dd8e8cddcdbb9156c2486eed5a43eccb7214d7c6828097d41ce049fb3984"; # 15-alpine
          environments = {
            POSTGRES_USER = "audiomuse";
            POSTGRES_DB = "audiomusedb";
          };
          environmentFiles = [ envFile ];
          volumes = [ "audiomuse-postgres:/var/lib/postgresql/data" ];
          dropCapabilities = [ "ALL" ];
          addCapabilities = [ "CHOWN" "DAC_READ_SEARCH" "FOWNER" "SETGID" "SETUID" ];
          noNewPrivileges = true;
        };
        unitConfig.Description = "AudioMuse-AI PostgreSQL";
        serviceConfig.Restart = "always";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
}
