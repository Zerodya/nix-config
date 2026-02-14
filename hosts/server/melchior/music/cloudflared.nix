{ config, ...}:

{
  services.cloudflared = {
    tunnels = {
      "440a294d-ad13-4186-aaae-81235cff18dd" = {
        credentialsFile = "${config.sops.secrets.cloudflared-music.path}";
        ingress = {
         "navidrome.zerodya.net" = "http://127.0.0.1:4533";
        };
        default = "http_status:404";
      };
    };
  };
}