{ config, pkgs, ... }:
let
  # Public key shown by the hub under "Add System" after first login. Not a secret.
  # The agent stays disabled until this is set.
  hub-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ1Asd+sD/qjihIAkCQVcmBB98cXvGfUkWirWHQObSm";
in
{
  # ===== Beszel =====
  # Dashboard: http://melchior:8090 (LAN only). Metric alerts (CPU, RAM, disk, network)
  # and their Discord webhook are configured in the web UI: Settings > Notifications.
  services.beszel.hub = {
    enable = true;
    host = "0.0.0.0";
    port = 8090;
  };

  # Hub connects to the agent over localhost: in "Add System" use host 127.0.0.1, port 45876
  services.beszel.agent = {
    enable = hub-key != "";
    environment = {
      LISTEN = "127.0.0.1:45876";
      KEY = hub-key;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8090 ];

  # ===== Failed service alerts =====
  # Every service gets OnFailure=notify-discord@<unit>, following the systemd.unit(5) example
  systemd.packages = [
    (pkgs.writeTextDir "lib/systemd/system/service.d/10-notify-discord.conf" ''
      [Unit]
      OnFailure=notify-discord@%N.service
    '')
    # Same file name, empty: the notifier itself doesn't get the hook (no recursion)
    (pkgs.writeTextDir "lib/systemd/system/notify-discord@.service.d/10-notify-discord.conf" "")
  ];

  systemd.services."notify-discord@" = {
    description = "Discord alert for failed unit %i";
    scriptArgs = "%i";
    script = ''
      msg=":red_circle: **$1** failed on ${config.networking.hostName}. \`journalctl -u $1\`"
      ${pkgs.curl}/bin/curl -fsS -H 'Content-Type: application/json' \
        -d "$(${pkgs.jq}/bin/jq -n --arg msg "$msg" '{content: $msg}')" \
        "$(cat "$CREDENTIALS_DIRECTORY/webhook")"
    '';
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      LoadCredential = "webhook:${config.sops.secrets.discord-webhook.path}";
    };
  };
}
