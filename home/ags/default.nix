{ inputs, pkgs, ... }:
{
  imports = [ 
    inputs.ags.homeManagerModules.default

    ./scripts/stylix-colors.nix # Generate colors with Stylix
  ];

  # Dependencies
  home.packages = with pkgs; [
    sassc # converts .sccs to .css (for ags)
    inotify-tools # for notifications
    papirus-icon-theme # for launcher icons
    brightnessctl # hard dependency for now, fix later
    jq # to parse stylix json colors in script
  ];

  programs.ags = {
    enable = true;

    configDir = ../ags;

    # extraPackages = with pkgs; [
    #   gtksourceview
    #   webkitgtk
    #   accountsservice
    # ];
  };

}