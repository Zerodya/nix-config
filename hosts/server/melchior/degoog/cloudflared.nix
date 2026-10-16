{ config, ...}:

{
  services.cloudflared = {
    tunnels = {
      "bc710229-870a-4b44-add5-f63b6d719d13" = {
        credentialsFile = "${config.sops.secrets.cloudflared-degoog.path}";
        ingress = {
         "search.zerodya.net" = "http://localhost:8096";
        };
        default = "http_status:404";
      };
    };
  };
}
