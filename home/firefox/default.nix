{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    configPath = "${config.home.homeDirectory}/.mozilla/firefox";

    # Declare “profiles” to manage multiple profiles
    profiles = {
      alpha = {
        isDefault = true;
        
        # user.js settings
        settings = {};
        extraConfig = builtins.readFile ./user.js;

        # userChrome.css
        userChrome = ''
          ${builtins.readFile ./treestyletab.css}
        '';

        # Search engine config
        search = {
          force = true;
          default = "degoog";
          order = [ "degoog" "nix-pkgs" "nixos-wiki" "ddg" ];

          engines = {
            degoog = {
              urls = [
                { template = "https://search.zerodya.net/search?q={searchTerms}"; }
              ];
              icon = "https://search.zerodya.net/public/favicon/favicon.ico";
              updateInterval = 86400000; # 24h
              definedAliases = [ "@degoog" ];
              suggestUrls = [
                { template = "https://search.zerodya.net/api/suggest/opensearch?q={searchTerms}"; }
              ];
            };

            "nix-pkgs" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }
              ];
              icon = "https://nixos.org/favicon.svg";
              definedAliases = [ "@np" ];
            };

            "nixos-wiki" = {
              urls = [
                { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
              ];
              icon = "https://nixos.org/favicon.svg";
              updateInterval = 86400000;
              definedAliases = [ "@nw" ];
            };

            ddg = {
              urls = [
                { template = "https://duckduckgo.com/?q={searchTerms}"; }
              ];
              definedAliases = [ "@ddg" ];
            };

            # Hide from the UI
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
          };
        };
      };
    };
  };
}
