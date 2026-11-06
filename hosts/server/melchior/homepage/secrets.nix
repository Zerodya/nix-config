{ config, ... }:
let
  sopsFile = ../../../../secrets/homepage.yaml;
in
{
  sops.secrets = {
    "homepage/immich-key" = { inherit sopsFile; };
    "homepage/beszel-user" = { inherit sopsFile; };
    "homepage/beszel-pass" = { inherit sopsFile; };
    "homepage/navidrome-user" = { inherit sopsFile; };
    "homepage/navidrome-token" = { inherit sopsFile; };
    "homepage/navidrome-salt" = { inherit sopsFile; };
  };

  sops.templates."homepage.env" = {
    restartUnits = [ "homepage-dashboard.service" ];
    content = ''
      HOMEPAGE_VAR_IMMICH_KEY=${config.sops.placeholder."homepage/immich-key"}
      HOMEPAGE_VAR_BESZEL_USER=${config.sops.placeholder."homepage/beszel-user"}
      HOMEPAGE_VAR_BESZEL_PASS=${config.sops.placeholder."homepage/beszel-pass"}
      HOMEPAGE_VAR_NAVIDROME_USER=${config.sops.placeholder."homepage/navidrome-user"}
      HOMEPAGE_VAR_NAVIDROME_TOKEN=${config.sops.placeholder."homepage/navidrome-token"}
      HOMEPAGE_VAR_NAVIDROME_SALT=${config.sops.placeholder."homepage/navidrome-salt"}
      HOMEPAGE_VAR_SLSKD_KEY=${config.sops.placeholder."slskd/apikey"}
    '';
  };

  services.homepage-dashboard.environmentFiles = [ config.sops.templates."homepage.env".path ];
}
