{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;  

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
          default = "searxng";
          order = [ "searxng" "nix-pkgs" "nixos-wiki" "ddg" ];

          engines = {
            searxng = {
              urls = [
                { template = "https://searx.zerodya.net/search?q={searchTerms}"; }
              ];
              icon = "https://searx.zerodya.net/favicon.ico";
              updateInterval = 86400000; # 24h
              definedAliases = [ "@searxng" ];
              suggestUrls = [
                { template = "https://searx.zerodya.net/autosuggest?q={searchTerms}"; }
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

  stylix.targets.firefox.profileNames = [ "alpha" ];
  stylix.enableReleaseChecks = false;
}
