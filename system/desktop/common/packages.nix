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

  # Core system packages
  environment.systemPackages = with pkgs; [
    gnumake
    rustc
    cargo
    kitty
    playerctl
    polkit
    polkit_gnome
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    gsettings-desktop-schemas
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

    # File manager
    nautilus 
  ];

  # Other programs
  programs = {
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    kdeconnect.enable = true;
    adb.enable = true;
  };

  # Run AppImages 
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Run FHS binaries (example usage: LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH steam-run ./my_application )
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # MOD-Desktop at https://github.com/mod-audio/mod-desktop
      alsa-lib
      libsndfile
    ];
  };
}