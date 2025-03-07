{ inputs, pkgs, ... }:
{
  imports = [ 
    inputs.ags.homeManagerModules.default
  ];

  # Dependencies
  home.packages = with pkgs; [
    sassc # converts .sccs to .css (for ags)
    inotify-tools # for notifications
    papirus-icon-theme # for launcher icons
    brightnessctl # hard dependency for now, fix later
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

  # Fix floating tray icon for Wine applications in AGS/Hyprland
  services.xembed-sni-proxy.enable = true;
  services.xembed-sni-proxy.package = pkgs.kdePackages.plasma-workspace;

}