{ config, pkgs, ... }:

{
  # Import every other programs file
  imports = [
    ./fish.nix
    ./kitty.nix
    ./starship.nix
  ];
}