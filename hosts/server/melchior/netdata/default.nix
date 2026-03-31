{ pkgs, config, ... }:

let
  discord-webhook = config.sops.secrets.discord-webhook.path;
in

{
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { 
      withCloudUi = true;
      withSystemdJournal = true;  # Enable systemd journal plugin for service monitoring
    };
    
    config.global = {
      "memory mode" = "ram";
      "debug log" = "none";
      "access log" = "none";
      "error log" = "syslog";
    };

    # Enable systemd units collector
    configDir."go.d/systemdunits.conf" = pkgs.writeText "systemdunits.conf" ''
      jobs:
        - name: service-units
          include:
            - '*.service'
    '';

    # Health alarm for failed services (disabled by default upstream)
    configDir."health.d/systemdunits.conf" = pkgs.writeText "systemdunits.conf" ''
      alarm: systemd_service_unit_failed_state
      on: systemd.service_unit_state
      class: Errors
      type: Linux
      component: Systemd units
      calc: $failed
      units: state
      every: 10s
      crit: $this != nan AND $this == 1
      delay: down 5m multiplier 1.5 max 1h
      info: systemd service unit in the failed state
      to: sysadmin
    '';

    # Discord notification config
    configDir."health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" ''
      SEND_DISCORD="YES"
      DISCORD_WEBHOOK_URL="$(cat ${discord-webhook})"
      DEFAULT_RECIPIENT_DISCORD="sysadmin"
    '';
    };

  networking.firewall.allowedTCPPorts = [ 19999 ];

  # Ensure netdata can read the webhook secret
  systemd.services.netdata.serviceConfig.LoadCredential = [
    "discord-webhook:${discord-webhook}"
  ];
}