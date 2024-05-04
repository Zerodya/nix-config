{ pkgs, lib, ... }:

{
  imports = [
    ./users.nix
    ./security.nix
  ];

  # Cachix cache
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
  };

  # Systemd-boot
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  # Nix Store
  nix.gc = {
    automatic = true;
    dates = "12:00";
    options = "--delete-older-than 4d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "12:30" ];
  };

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

    gnome.gnome-shell-extensions
  ];

  programs = {
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

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other
  };
  virtualisation.oci-containers.backend = "podman";

  # SSH
  services.openssh = {
    enable = true;
    # settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  # Do not change this
  system.stateVersion = "23.11";
}

