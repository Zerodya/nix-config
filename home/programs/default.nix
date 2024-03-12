{ config, pkgs, ... }:

{
  # Import every other programs file
  imports = [
    ./applications.nix
    
  ];
}