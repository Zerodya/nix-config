{
  description = "My Home-Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    ags.url = "github:Aylur/ags";

    matugen.url = "github:/InioX/Matugen";

    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    ...
  } @ inputs:

  let
    username = "alpha";
    desktop = "eva01";
    laptop = "eva02";
  in 
  
  {
    nixosConfigurations = {
      # Desktop Ryzen 5 5600X, Radeon 6700XT, 16GB RAM
      ${desktop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit desktop; # pass desktop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix
          ./hosts/eva01/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/eva01/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
          chaotic.nixosModules.default
        ];
      };

      # Laptop Thinkpad E15 Gen 1, i5-10210U, 16GB RAM
      ${laptop} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit laptop; # pass laptop hostname
        };
        system = "x86_64-linux";

        modules = [
          ./system/core/default.nix
          ./hosts/eva02/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/eva02/home.nix;
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
