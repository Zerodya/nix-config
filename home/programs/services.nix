{ pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    openvpn
    syncthing
    aria
  ];
}