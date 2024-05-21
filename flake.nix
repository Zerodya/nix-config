{
  description = "My Home-Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    #hyprland.url = "github:hyprwm/Hyprland";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # Temporary fix for build issue https://github.com/hyprwm/Hyprland/issues/5891
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    ags.url = "github:Aylur/ags";

    #matugen.url = "github:/InioX/Matugen";
    matugen.url = "github:InioX/matugen?ref=v2.2.0"; # Temporary fix for build issue https://github.com/InioX/matugen/issues/70

    umu.url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
    umu.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    nixos-hardware,
    ...
  } @ inputs:

  let
    username = "alpha";

    desktop = "eva01";
    laptop = "eva02";

    media-server = "media";
    misc-server = "misc";
    public-server = "public";
    music-server = "music";
    minecraft-server = "minecraft";
  in 
  
  {
    nixosConfigurations = {
      # Desktop - Ryzen 5 5600X, Radeon 6700XT, 16GB RAM
      ${desktop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit desktop; # pass desktop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/desktop/common/default.nix
          ./hosts/desktop/eva01/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/eva01/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          chaotic.nixosModules.default
        ];
      };

      # Laptop - Thinkpad E15 Gen 1, i5-10210U, 16GB RAM
      ${laptop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit laptop; # pass laptop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/desktop/common/default.nix
          ./hosts/desktop/eva02/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/eva02/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          nixos-hardware.lenovo-thinkpad-e14-intel
        ];
      };

      # Server - Media streaming with Jellyfin
      ${media-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit media-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/server/common/default.nix
          ./hosts/server/media/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/media/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # Server - Miscellaneous services (Homepage, Pi-Hole, etc.)
      ${misc-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit misc-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/server/common/default.nix
          ./hosts/server/misc/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/misc/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # Server - Public services (SearXNG, Piped, etc.)
      ${public-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit public-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/server/common/default.nix
          ./hosts/server/public/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/public/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # Server - Music streaming with Navidrome
      ${music-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit music-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/server/common/default.nix
          ./hosts/server/music/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/music/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # Server - Minecraft 
      ${minecraft-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit minecraft-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix

          ./system/server/common/default.nix
          ./hosts/server/minecraft/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/minecraft/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

    };
  };
}
