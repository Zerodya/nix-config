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
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Caelestia Shell
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic repo (cachyos kernel, mesa-git, ...)
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Base16 system-wide colorscheming
    stylix.url = "github:danth/stylix";

    # Declarative Flatpak
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/dev";
  };

  outputs = {
    nixpkgs,
    home-manager,
    determinate,
    nur,
    nixos-hardware,
    chaotic,
    stylix,
    flatpaks,
    ...
  } @ inputs:

  let
    username = "alpha";

    desktop = "eva01";
    laptop = "eva02";

    pi4 = "casper";
    thinkcentre = "melchior";
  in 
  
  {
    nixosConfigurations = {
      # ~~ Desktop | Ryzen 5 5600X, Radeon 6700XT, 16GB RAM ~~
      ${desktop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit desktop; # pass hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config
          ./system/desktop/common/default.nix # Desktop common config

          ./hosts/desktop/${desktop}/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/${desktop}/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          
          determinate.nixosModules.default # Determinate Systems Nix
          nur.modules.nixos.default # Nix User Repository
          chaotic.nixosModules.default # Chaotic repo
          stylix.nixosModules.stylix # Base16 colorscheming
          flatpaks.nixosModules.default # Declarative Flatpak
        ];
      };


      # ~~ Laptop | Thinkpad E15 Gen 1, i5-10210U, 16GB RAM ~~
      ${laptop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit laptop; # pass hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config
          ./system/desktop/common/default.nix # Desktop common config

          ./hosts/desktop/${laptop}/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/desktop/${laptop}/home.nix; # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          
          determinate.nixosModules.default # Determinate Systems Nix
          nur.modules.nixos.default # Nix User Repository
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel # Hardware module
          stylix.nixosModules.stylix # Base16 colorscheming
          flatpaks.nixosModule # Declarative Flatpak
        ];
      };


      # ~~ Server | Raspberry Pi 4B ~~
      ${pi4} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit pi4; # pass hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config
          ./system/server/common/default.nix # Server common config

          ./hosts/server/${pi4}/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/${pi4}/home.nix;  # Host specific home config
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
        ];
      };

      # ~~ Server | ThinkCentre M720q ~~
      ${thinkcentre} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit thinkcentre; # pass hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix # Core config
          ./system/server/common/default.nix # Server common config

          ./hosts/server/${thinkcentre}/default.nix # Host specific system config

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/server/${thinkcentre}/home.nix; # Host specific home config
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
