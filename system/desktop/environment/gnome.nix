{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-shell-extensions
  ];

  # Exclude some Gnome packages
  environment.gnome.excludePackages =with pkgs; [
    gnome-tour
    gnome-text-editor
    gnome-browser-connector
    gnome-online-accounts
    gnome-user-docs
    gnome-user-share
    gnome-font-viewer
    gnome-system-monitor
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
    gnome-software
    gnome-music
    gnome-clocks
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-initial-setup
    gnome-music
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ];

  # Fix `programs.ssh.askPassword` conflict between Gnome's `seahorse` and Plasma's `ksshaskpass`
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

  # Gnome theme for Qt apps
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

}