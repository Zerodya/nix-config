{pkgs, lib, ...}: {

  # Allow Unfree and Insecure
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    gnumake
    rustc
    cargo
    kitty
    playerctl
    polkit
    polkit_gnome
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    ntfs3g
    adw-gtk3
    adwaita-qt
    adwaita-qt6
    corefonts
    glib
    glibc
    ffmpeg-full
    i2c-tools
    python3
    nodejs_22
    unzip
    xdotool
    xorg.xprop
    xorg.xwininfo
    yad
    socat
    slurp
    libnotify

    # Desktop GUI Applications
    nautilus # File manager
    sushi # Preview for Nautilus
    loupe # Image viewer
    gnome-calculator
    gnome-console
    gnome-disk-utility
  ];

  # Other programs
  programs = {
    kdeconnect.enable = true;
    dconf.enable = true; # Gnome/KDE theming?
    adb.enable = true;
  };

  # Flatpak
  services.flatpak.enable = true;

  # Dependencies for FHS binaries
  # Example usage: LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH steam-run ./mod-desktop-0.0.12-linux-x86_64/mod-desktop/mod-desktop
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # MOD-Desktop at https://github.com/mod-audio/mod-desktop
      alsa-lib
      libsForQt5.full
      libsndfile
    ];
  };
}