{ config, inputs, ... }:

{
  imports = [ inputs.degoog.nixosModules.default ];

  services.degoog = {
    enable = true;

    environmentFile = config.sops.templates."degoog.env".path;

    environment = {
      DEGOOG_BIND_ADDRESS = "127.0.0.1";
      DEGOOG_PORT = 4444;
      DEGOOG_PUBLIC_INSTANCE = true;
    };
  };

  # Degoog takes the first X-Forwarded-For entry, which Cloudflare lets clients prepend to.
  # Overwrite it with CF-Connecting-IP so rate limits and honeypot bans see the real visitor
  services.nginx = {
    enable = true;
    virtualHosts."search.zerodya.net" = {
      listen = [{ addr = "127.0.0.1"; port = 8096; }];
      locations."/" = {
        proxyPass = "http://127.0.0.1:4444";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $http_cf_connecting_ip;
          proxy_set_header X-Real-IP $http_cf_connecting_ip;
          proxy_buffering off; # page one streams over SSE
        '';
      };
    };
  };
}
