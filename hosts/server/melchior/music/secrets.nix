{ config, ... }:

{ 
  # music/navidrome
  sops.secrets = {
    "navidrome/lastfm/apikey" = {
      sopsFile = ../../../../secrets/music/navidrome.yaml;
      owner = "navidrome";
    };
    "navidrome/lastfm/secret" = {
      sopsFile = ../../../../secrets/music/navidrome.yaml;
      owner = "navidrome";
    };
    "navidrome/spotify/id" = {
      sopsFile = ../../../../secrets/music/navidrome.yaml;
      owner = "navidrome";
    };
    "navidrome/spotify/secret" = {
      sopsFile = ../../../../secrets/music/navidrome.yaml;
      owner = "navidrome";
    };
  };
  sops.templates."navidrome.env" = {
    owner = "navidrome";
    content = ''
      ND_LASTFM_APIKEY=${config.sops.placeholder."navidrome/lastfm/apikey"}
      ND_LASTFM_SECRET=${config.sops.placeholder."navidrome/lastfm/secret"}
      ND_SPOTIFY_ID=${config.sops.placeholder."navidrome/spotify/id"}
      ND_SPOTIFY_SECRET=${config.sops.placeholder."navidrome/spotify/secret"}
    '';
  };

  # music/slskd
  sops.secrets = {
    "slskd/soulseek/user" = {
      sopsFile = ../../../../secrets/music/slskd.yaml;
      owner = "slskd";
    };
    "slskd/soulseek/pass" = {
      sopsFile = ../../../../secrets/music/slskd.yaml;
      owner = "slskd";
    };
    "slskd/webui/user" = {
      sopsFile = ../../../../secrets/music/slskd.yaml;
      owner = "slskd";
    };
    "slskd/webui/pass" = {
      sopsFile = ../../../../secrets/music/slskd.yaml;
      owner = "slskd";
    };
  };
  sops.templates."slskd.env" = {
    owner = "slskd";
    content = ''
      SLSKD_SLSK_USERNAME=${config.sops.placeholder."slskd/soulseek/user"}
      SLSKD_SLSK_PASSWORD=${config.sops.placeholder."slskd/soulseek/pass"}
      SLSKD_USERNAME=${config.sops.placeholder."slskd/webui/user"}
      SLSKD_PASSWORD=${config.sops.placeholder."slskd/webui/pass"}
    '';
  };

}