{ pkgs, lib, ... }:

{
  imports = [
    ./users.nix
    ./security.nix
  ];

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nixpkgs Unfree and Insecure
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];
    permittedInsecurePackages = [
      "openssl-1.1.1w"
      "electron-25.9.0"
    ];
  };

  # Bootloader
  boot = {
    # Systemd-boot
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Time and Locale
  time.timeZone = "Europe/Rome";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # XServer
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  # Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Enable SSD TRIM timer https://www.reddit.com/r/NixOS/comments/rbzhb1/if_you_have_a_ssd_dont_forget_to_enable_fstrim/
  services.fstrim.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # TODO formatting and comments
  environment.systemPackages = with pkgs; [
    vim
    neovim
    btop
    wget
    git
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
    nodejs_21
    unzip
    xdotool
    xorg.xprop
    xorg.xwininfo
    yad
    socat
    slurp
    jq
    psmisc # killall/pstree/...
    pciutils # lspci
    usbutils # lsusb
    libnotify
    tree
    rar

    gnome.gdm
    gnome.gnome-shell-extensions
  ];

  # Gnome
  services.xserver.desktopManager.gnome.enable = true;
  # Exclude Gnome packages
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

  programs = {
    hyprland.enable = true;
    fish.enable = true;
    kdeconnect.enable = true;
    dconf.enable = true; # Gnome/KDE theming?
    adb.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code-nerdfont
    fira-code-symbols
    inconsolata-nerdfont
    terminus-nerdfont
    iosevka
    font-awesome # Icons
    source-han-sans # Japanese
  ];

  # Enable screen sharing
  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Do not change this
  system.stateVersion = "23.11";
}

