{ pkgs, ...}: {
  home.packages = with pkgs; [
    brightnessctl
    powertop

    bottles # For Uni Windows programs
  ];
}