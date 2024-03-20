{ inputs, pkgs, ... }:
{
  imports = [ 
    inputs.ags.homeManagerModules.default
    inputs.matugen.nixosModules.default
  ];

  # Dependencies
  home.packages = with pkgs; [
    sassc # converts .sccs to .css (for ags)
    inotify-tools # for notifications
    papirus-icon-theme # for launcher icons
    inputs.matugen.packages.${system}.default # generates colors (not working rn)
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

  programs.matugen = {
    enable = true;
  };
}