{ config, ... }:
{

  sops.secrets.searx = {
    sopsFile = ../../../../secrets/searx/searx.yaml;
    key = "SEARX_SECRET_KEY";
    owner = "searx";
    mode = "0400";
  };
  sops.templates."searx.env" = {
    owner = "searx";
    content = ''
      SEARX_SECRET_KEY=${config.sops.placeholder.searx}
    '';
  };

  sops.secrets.cloudflared-searx = {
    sopsFile = ../../../../secrets/searx/cloudflared-searx.yaml;
    key = "cloudflared-searx";
    mode = "0400";
  };
}