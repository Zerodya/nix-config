{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  # Exclude unnecessary KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # Utilities
    dolphin
    konsole
    kate
    kcalc
    okular
    gwenview
    ark
    kruler
    kfind
    kcharselect
    spectacle

    # Multimedia
    dragon
    elisa
    kdenlive

    # Graphics
    kolourpaint

    # Internet
    falkon
    kmail
    konversation
    ktorrent

    # Office
    korganizer

    # Development
    kdevelop

    # Education
    kalgebra
    marble
    kgeography
    ktouch

    # Other
    plasma-browser-integration
    oxygen

    # Additional packages
    baloo           # File indexing and search
    kmag            # Screen magnifier
    kmouth          # Speech synthesizer front-end
    kmousetool      # Automatic mouse click
    knotes          # Notes application
    krdc            # Remote desktop client
    krfb            # Remote desktop server
    kwalletmanager  # Wallet management tool
    yakuake         # Drop-down terminal
  ];

  # Gnome theme for Qt apps
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}