{
  description = "My Home-Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Systems Nix
    determinate.url = "github:DeterminateSystems/determinate/main"; 

     # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware modules
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Hyprland-git
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Chaotic repo (cachyos kernel, mesa-git, ...)
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Base16 system-wide colorscheming
    stylix.url = "github:danth/stylix";

    # Declarative Flatpak
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
  };

  outputs = {
    nixpkgs,
    home-manager,
    determinate,
    nur,
    chaotic,
    nixos-hardware,
    stylix,
    flatpaks,
    ...
  } @ inputs:

  let
    username = "alpha";

    desktop = "eva01";
    laptop = "eva02";

    media-server = "media";
    photos-server = "photos";
    misc-server = "misc";
    public-server = "public";
    music-server = "music";
    minecraft-server = "minecraft";
  in 
  
  {
    nixosConfigurations = {
      # ~~ Desktop | Ryzen 5 5600X, Radeon 6700XT, 16GB RAM ~~
      ${desktop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit desktop; # pass desktop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/desktop/common/default.nix # Desktop common config
          ./hosts/desktop/eva01/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/eva01/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          
          determinate.nixosModules.default # Determinate Systems Nix
          nur.modules.nixos.default # Nix User Repository
          chaotic.nixosModules.default # Chaotic repo
          stylix.nixosModules.stylix # Base16 colorscheming
          flatpaks.nixosModules.declarative-flatpak # Declarative Flatpak
        ];
      };


      # ~~ Laptop | Thinkpad E15 Gen 1, i5-10210U, 16GB RAM ~~
      ${laptop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit laptop; # pass laptop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/desktop/common/default.nix # Desktop common config
          ./hosts/desktop/eva02/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/eva02/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          
          determinate.nixosModules.default # Determinate Systems Nix
          nur.modules.nixos.default # Nix User Repository
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel # Hardware module
          stylix.nixosModules.stylix # Base16 colorscheming
          flatpaks.nixosModules.declarative-flatpak # Declarative Flatpak
        ];
      };


      # ~~ Server | Media streaming with Jellyfin ~~
      ${media-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit media-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/media/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/media/home.nix;  # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | Photos library with Immich ~~
      ${photos-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit photos-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/photos/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/photos/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | Miscellaneous services (Homepage, Pi-Hole, etc.) ~~
      ${misc-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit misc-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/misc/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/misc/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | Public services (SearXNG, Piped, etc.) ~~
      ${public-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit public-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/public/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/public/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | Music streaming with Navidrome ~~
      ${music-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit music-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/music/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/music/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | Minecraft ~~
      ${minecraft-server} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit minecraft-server;
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config

          ./system/server/common/default.nix # Server common config
          ./hosts/server/minecraft/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/minecraft/home.nix; # Host specific home config
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
