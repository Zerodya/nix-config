{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openvpn
    syncthing
    aria2
  ];
}