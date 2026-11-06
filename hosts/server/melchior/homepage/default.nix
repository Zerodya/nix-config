{ ... }:
let
  port = 8082;
  lan-ip = "192.168.1.201";

  # Links are opened by the browser, status checks and widgets run on the server itself
  lan = p: "http://${lan-ip}:${toString p}";
  local = p: "http://127.0.0.1:${toString p}";
in
{
  # Dashboard: http://192.168.1.201:8082 (LAN only)
  services.homepage-dashboard = {
    enable = true;
    listenPort = port;
    allowedHosts = "${lan-ip}:${toString port}";

    settings = {
      title = "Melchior";
      theme = "dark";
      disableUpdateCheck = true; # updates come from nixpkgs
    };

    widgets = [{
      resources = {
        cpu = true;
        memory = true;
        cputemp = true;
        uptime = true;
        network = "eno1";
        disk = [ "/" "/mnt/storage" "/mnt/backups" ];
        expanded = true;
      };
    }];

    services = [
      {
        Music = [
          {
            Navidrome = {
              icon = "navidrome.png";
              description = "Music streaming";
              href = "https://navidrome.zerodya.net";
              siteMonitor = local 4533;
              widget = {
                type = "navidrome";
                url = local 4533;
                user = "{{HOMEPAGE_VAR_NAVIDROME_USER}}";
                token = "{{HOMEPAGE_VAR_NAVIDROME_TOKEN}}";
                salt = "{{HOMEPAGE_VAR_NAVIDROME_SALT}}";
              };
            };
          }
          {
            slskd = {
              icon = "slskd.png";
              description = "Soulseek client";
              href = lan 5030;
              siteMonitor = local 5030;
              widget = {
                type = "slskd";
                url = local 5030;
                key = "{{HOMEPAGE_VAR_SLSKD_KEY}}";
              };
            };
          }
          {
            "Rate Your Music" = {
              icon = "mdi-star-outline";
              description = "Album recommendations";
              href = "https://rateyourmusic.com/recommendations/The_AlphaCeph/release/";
            };
          }
          {
            DroppedNeedle = {
              icon = "mdi-album";
              description = "Music requests";
              href = lan 8688;
              siteMonitor = local 8688;
            };
          }
          {
            AudioMuse-AI = {
              icon = "mdi-waveform";
              description = "Sonic analysis";
              href = lan 8000;
              siteMonitor = local 8000;
            };
          }
        ];
      }
      {
        Photos = [{
          Immich = {
            icon = "immich.png";
            description = "Photo library";
            href = lan 2283;
            siteMonitor = local 2283;
            widget = {
              type = "immich";
              url = local 2283;
              key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
              version = 2;
            };
          };
        }];
      }
      {
        Monitoring = [{
          Beszel = {
            icon = "beszel.png";
            description = "Server monitoring";
            href = lan 8090;
            siteMonitor = local 8090;
            widget = {
              type = "beszel";
              url = local 8090;
              username = "{{HOMEPAGE_VAR_BESZEL_USER}}";
              password = "{{HOMEPAGE_VAR_BESZEL_PASS}}";
              version = 2;
            };
          };
        }];
      }
      {
        Web = [
          {
            Degoog = {
              icon = "mdi-magnify";
              description = "Search engine";
              href = "https://search.zerodya.net";
              siteMonitor = local 4444;
            };
          }
          {
            Blog = {
              icon = "mdi-post-outline";
              description = "zerodya.net";
              href = "https://zerodya.net";
              siteMonitor = local 8095;
            };
          }
        ];
      }
    ];
  };

  networking.firewall.interfaces.eno1.allowedTCPPorts = [ port ]; # LAN
}
