{ config, lib, ...}:

{
  services.searx = {
    enable = true;

    environmentFile = config.sops.templates."searx.env".path;

    # Rate limiting
    redisCreateLocally = true;
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 56;
      };
      botdetection = {
        ip_limit = {
          filter_link_local = true;
          link_token = true;
        };
      };
    };

    # UWSGI configuration
    configureUwsgi = true;
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      http = ":8080";
      chmod-socket = "660";
    };

    # Searx configuration
    settings = {
      # Instance settings
      general = {
        debug = false;
        instance_name = "SearXNG Zerodya";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      # User interface
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = false;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "light";
        search_on_category_select = false;
        hotkeys = "vim";
      };

      # Search engine settings
      search = {
        favicon_resolver = "duckduckgo";
        safe_search = 0;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        suspended_times = {
          SearxEngineAccessDenied = 60;         # 1 minute for "Access denied" / HTTP 402-403
          SearxEngineCaptcha = 86400;           # 24 hours for CAPTCHA
          SearxEngineTooManyRequests = 3600;    # 1 hour for "Too many requests" / HTTP 429
          cf_SearxEngineCaptcha = 1296000;      # 15 days for Cloudflare CAPTCHA
          cf_SearxEngineAccessDenied = 86400;   # 24 hours for Cloudflare "Access denied"
        };
      };

      # Server configuration
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        secret_key = "$SEARX_SECRET_KEY";
        limiter = true;
        public_instance = true;
        image_proxy = true;
        method = "GET";
      };

      # Search engines
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "duckduckgo".disabled = false;
        "brave".disabled = true;
        "bing".disabled = true;
        "mojeek".disabled = true;
        "mwmbl".disabled = true;
        "qwant".disabled = true;
        "startpage".disabled = false;
        "crowdview".disabled = false;
        "crowdview".weight = 0.5;
        "curlie".disabled = true;
        "ddg definitions".disabled = false;
        "ddg definitions".weight = 2;
        "wikibooks".disabled = false;
        "wikidata".disabled = false;
        "wikiquote".disabled = true;
        "wikisource".disabled = true;
        "wikispecies".disabled = true;
        "wikiversity".disabled = true;
        "wikivoyage".disabled = true;
        "currency".disabled = true;
        "dictzone".disabled = true;
        "lingva".disabled = true;
        "bing images".disabled = false;
        "brave.images".disabled = true;
        "duckduckgo images".disabled = true;
        "google images".disabled = false;
        "qwant images".disabled = true;
        "1x".disabled = true;
        "artic".disabled = false;
        "deviantart".disabled = false;
        "flickr".disabled = true;
        "imgur".disabled = false;
        "library of congress".disabled = false;
        "material icons".disabled = true;
        "material icons".weight = 0.2;
        "openverse".disabled = false;
        "pinterest".disabled = true;
        "svgrepo".disabled = false;
        "unsplash".disabled = false;
        "wallhaven".disabled = false;
        "wikicommons.images".disabled = false;
        "yacy images".disabled = true;
        "bing videos".disabled = false;
        "brave.videos".disabled = true;
        "duckduckgo videos".disabled = true;
        "google videos".disabled = false;
        "qwant videos".disabled = false;
        "dailymotion".disabled = true;
        "google play movies".disabled = true;
        "invidious".disabled = true;
        "odysee".disabled = true;
        "peertube".disabled = false;
        "piped".disabled = true;
        "rumble".disabled = false;
        "sepiasearch".disabled = false;
        "vimeo".disabled = true;
        "youtube".disabled = false;
        "brave.news".disabled = true;
        "google news".disabled = true;
      };

      # Outgoing requests
      outgoing = {
        request_timeout = 5.0;
        max_request_timeout = 15.0;
        pool_connections = 100;
        pool_maxsize = 15;
        enable_http2 = true;
      };

      # Enabled plugins
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };

    faviconsSettings = {
      favicons = {
        cfg_schema = 1;
        cache = {
          db_url = "/var/cache/searx/faviconcache.db";
          HOLD_TIME = 5184000;        # 60 days in seconds
          LIMIT_TOTAL_BYTES = 2147483648;  # 2GB max
          BLOB_MAX_BYTES = 40960;     # 40KB per favicon
          MAINTENANCE_MODE = "auto";  # Auto-cleanup old entries
          MAINTENANCE_PERIOD = 600;   # Cleanup every 10 minutes
        };
      };
    };
  };
}