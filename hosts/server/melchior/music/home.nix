{ pkgs, ... }:

{
  home.packages = with pkgs; [
    beets
  ];

  # Beets configuration
  home.file.".config/beets/config.yaml".source = ./beets-config.yaml;
}