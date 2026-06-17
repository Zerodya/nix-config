{ config, ... }:
{
  services.cloudflared = {
    tunnels = {
      "1c901a30-06f8-410d-9179-f6440cc0fe3d" = {
        credentialsFile = "${config.sops.secrets.cloudflared-fitness.path}";
        ingress = {
          "fitness.zerodya.net" = "http://localhost:3004";
        };
        default = "http_status:404";
      };
    };
  };
}