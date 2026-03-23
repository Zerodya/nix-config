{ config, ...}:

{
  services.cloudflared = {
    tunnels = {
      "bc710229-870a-4b44-add5-f63b6d719d13" = {
        credentialsFile = "${config.sops.secrets.cloudflared-searx.path}";
        ingress = {
         "searx.zerodya.net" = "http://localhost:8080";
        };
        default = "http_status:404";
      };
    };
  };
}