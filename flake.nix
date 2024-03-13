{
  description = "My Home-Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";

    matugen.url = "github:/InioX/Matugen";

    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:

  let
    username = "alpha";
    desktop = "EVA-Unit01";
    laptop = "EVA-Unit02";
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
          ./hosts/EVA-Unit01/default.nix
          ./system/modules/rt-audio.nix
          ./system/modules/gaming.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
            };
          }
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
          ./hosts/EVA-Unit02/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/home.nix;
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
