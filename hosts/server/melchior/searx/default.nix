{ config, ... }:

{
  services.searx = {
    enable = true;
    
    environmentFile = config.sops.secrets.searx.path;
    
    # No Nginx since I'm using a Cloudflare Tunnel
    configureUwsgi = true;
    configureNginx = false;

    # Rate limiting and bot protection
    redisCreateLocally = true;

    settings = {
      general = {
        debug = false;
        instance_name = "SearX";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
      };
      
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        secret_key = "$SEARX_SECRET_KEY";
        limiter = true;
      };
      
      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        default_lang = "auto";
        formats = [ "html" "json" ];
      };
      
      ui = {
        static_use_hash = true;
        theme_args.style = "auto";
        results_on_new_tab = true;
      };
      
      outgoing = {
        request_timeout = 10.0;
        max_request_timeout = 15.0;
        pool_connections = 100;
        pool_maxsize = 20;
        enable_http2 = true;
      };
      
      engines = [
        # --- Web General ---
        {
          name = "brave";
          engine = "brave";
          shortcut = "br";
          enabled = true;
        }
        {
          name = "duckduckgo";
          engine = "duckduckgo";
          shortcut = "ddg";
          enabled = true;
        }
        {
          name = "google";
          engine = "google";
          shortcut = "go";
          enabled = true;
        }
        {
          name = "startpage";
          engine = "startpage";
          shortcut = "sp";
          enabled = true;
        }
        
        # --- Translate ---
        {
          name = "lingva";
          engine = "lingva";
          shortcut = "lv";
          enabled = true;
        }
        
        # --- Wikipedia (no subgrouping) ---
        {
          name = "wikipedia";
          engine = "wikipedia";
          shortcut = "wp";
          enabled = true;
          categories = "general";
        }
        
        # --- Web Images ---
        {
          name = "google images";
          engine = "google_images";
          shortcut = "gimg";
          categories = "images";
          enabled = true;
        }
        
        # --- Icons ---
        {
          name = "devicons";
          engine = "devicons";
          shortcut = "dev";
          categories = "images";
          enabled = true;
        }
        {
          name = "lucide";
          engine = "lucide";
          shortcut = "lc";
          categories = "images";
          enabled = true;
        }
        
        # --- Images (no subgrouping) ---
        {
          name = "pinterest";
          engine = "pinterest";
          shortcut = "pin";
          categories = "images";
          enabled = true;
        }
        
        # --- Videos ---
        {
          name = "google videos";
          engine = "google_videos";
          shortcut = "vid";
          categories = "videos";
          enabled = true;
        }
        
        # --- News ---
        {
          name = "startpage news";
          engine = "startpage_news";
          shortcut = "spn";
          categories = "news";
          enabled = true;
        }
        {
          name = "google news";
          engine = "google_news";
          shortcut = "gon";
          categories = "news";
          enabled = true;
        }
        {
          name = "yahoo news";
          engine = "yahoo_news";
          shortcut = "yan";
          categories = "news";
          enabled = true;
        }
        
        # --- Maps ---
        {
          name = "openstreetmap";
          engine = "openstreetmap";
          shortcut = "osm";
          categories = "map";
          enabled = true;
        }
      ];
      
      # Categories configuration
      categories = {
        general = {
          engines = [ "brave" "duckduckgo" "google" "startpage" "wikipedia" ];
        };
        images = {
          engines = [ "google images" "devicons" "lucide" "duckduckgo images" "pinterest" ];
        };
        videos = {
          engines = [ "google videos" ];
        };
        news = {
          engines = [ "startpage news" "google news" "yahoo news" ];
        };
        map = {
          engines = [ "openstreetmap" ];
        };
        translate = {
          engines = [ "lingva" ];
        };
      };
      
      # Disable unused engines from defaults
      use_default_settings = {
        enable = true;
        engines = {
          remove = [
            "bing"
            "bing images"
            "bing videos"
            "bing news"
            "qwant"
            "qwant images"
            "qwant news"
            "qwant videos"
            "wikidata"
          ];
        };
      };
    };
    
    # uWSGI configuration - HTTP mode for Cloudflare Tunnel
    uwsgiConfig = {
      http = "127.0.0.1:8080";
      processes = 4;
      threads = 4;
      max-requests = 1000;
      disable-logging = true;
    };
  };

  # Not required with Cloudflare Tunnel
  #networking.firewall.allowedTCPPorts = [ 8080 ];
}