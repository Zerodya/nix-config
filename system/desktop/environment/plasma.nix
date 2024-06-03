{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  # Exclude some KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  # Gnome theme for Qt apps
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}