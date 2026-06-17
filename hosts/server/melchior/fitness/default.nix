{ config, ... }:
let
  servicePort = "3004";
  internalPort = "80"; # frontend nginx port
  inherit (config.virtualisation.quadlet) pods;
  version = "v0.16.6.1";
  envFile = config.sops.templates."sparkyfitness.env".path;
in
{
  virtualisation.quadlet = {
    enable = true;
    pods.sfpod = {
      podConfig = {
        publishPorts = [
          "0.0.0.0:${servicePort}:${internalPort}"
        ];
      };
      autoStart = true;
    };
    containers = {
      sffrontend = {
        containerConfig = {
          pod = pods.sfpod.ref;
          image = "docker.io/codewithcj/sparkyfitness:${version}";
          environmentFiles = [ envFile ];
          dropCapabilities = [ "ALL" ];
          addCapabilities = [
            "CHOWN"
            "NET_BIND_SERVICE"
            "SETGID"
            "SETUID"
          ];
          noNewPrivileges = true;
        };
        unitConfig = {
          Description = "SparkyFitness Frontend";
          After = [ "sfserver.service" ];
          Requires = [ "sfserver.service" ];
        };
        serviceConfig.Restart = "always";
      };
      sfserver = {
        containerConfig = {
          pod = pods.sfpod.ref;
          image = "docker.io/codewithcj/sparkyfitness_server:${version}";
          environmentFiles = [ envFile ];
          volumes = [
            "sf-server-backup:/app/SparkyFitnessServer/backup:Z"
            "sf-server-uploads:/app/SparkyFitnessServer/uploads:Z"
          ];
          dropCapabilities = [ "ALL" ];
          noNewPrivileges = true;
        };
        unitConfig = {
          Description = "SparkyFitness Server";
          After = [ "sfpostgres.service" ];
          Requires = [ "sfpostgres.service" ];
        };
        serviceConfig.Restart = "always";
      };
      sfpostgres = {
        containerConfig = {
          pod = pods.sfpod.ref;
          image = "docker.io/library/postgres:17-alpine";
          volumes = [ "sf-postgres:/var/lib/postgresql/data:Z" ];
          environmentFiles = [ envFile ];
          dropCapabilities = [ "ALL" ];
          addCapabilities = [
            "CHOWN"
            "DAC_READ_SEARCH"
            "FOWNER"
            "SETGID"
            "SETUID"
          ];
          noNewPrivileges = true;
        };
        unitConfig.Description = "SparkyFitness PostgreSQL Database";
        serviceConfig.Restart = "always";
      };
    };
    volumes = {
      "sf-postgres" = { };
      "sf-server-backup" = { };
      "sf-server-uploads" = { };
    };
  };
}