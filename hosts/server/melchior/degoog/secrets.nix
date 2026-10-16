{ config, ... }:
{

  sops.secrets.degoog = {
    sopsFile = ../../../../secrets/degoog/degoog.yaml;
    key = "DEGOOG_SETTINGS_PASSWORDS";
    mode = "0400";
  };
  sops.templates."degoog.env" = {
    content = ''
      DEGOOG_SETTINGS_PASSWORDS=${config.sops.placeholder.degoog}
    '';
    restartUnits = [ "degoog.service" ];
  };

  sops.secrets.cloudflared-degoog = {
    sopsFile = ../../../../secrets/degoog/cloudflared-degoog.yaml;
    key = "cloudflared-degoog";
    mode = "0400";
  };
}
