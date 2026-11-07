{ pkgs, ...}: {
  home.packages = with pkgs; [
    brightnessctl
    powertop
    wl-mirror
  ];
}