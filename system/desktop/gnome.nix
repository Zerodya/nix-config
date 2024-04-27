{ pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude some Gnome packages
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-text-editor
    gnome-browser-connector
    gnome-online-accounts
    gnome-user-docs
  ]) ++ (with pkgs.gnome; [
    gnome-software
    gnome-music
    gnome-user-share
    gnome-clocks
    gnome-maps
    gnome-weather
    gnome-online-miners
    gnome-contacts
    gnome-font-viewer
    gnome-system-monitor
    gnome-initial-setup
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
]);

}