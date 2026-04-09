{ config, ... }:
let
  flakePath = "${config.home.homeDirectory}/nix-config"; 
in
{
  home.file.".config/DankMaterialShell/settings.json".source = 
    config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/dank/settings.json";
}