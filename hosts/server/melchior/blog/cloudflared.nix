{ config, ...}:

{
  services.cloudflared = {
    tunnels = {
      "c25d9692-b2c5-4a0b-aa4a-b35603b73d90" = {
        credentialsFile = "${config.sops.secrets.cloudflared-blog.path}";
        ingress = {
         "zerodya.net" = "http://localhost:8095";
        };
        default = "http_status:404";
      };
    };
  };
}
