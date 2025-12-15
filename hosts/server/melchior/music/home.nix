{ pkgs, ... }:

{
  home.packages = with pkgs; [
    beets
  ];
}