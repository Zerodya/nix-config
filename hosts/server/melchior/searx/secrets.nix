{
  sops.secrets.searx = {
    sopsFile = ../../../../secrets/searx/searx.yaml; 
    owner = "searx";
    key = "SEARX_SECRET_KEY"; 
    mode = "0400";
  };

  sops.secrets.cloudflared-searx = {
    sopsFile = ../../../../secrets/searx/cloudflared-searx.yaml;
    key = "cloudflared-searx";
    mode = "0400";
  };
}