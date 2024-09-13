{ pkgs, ... }:

{
  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # XServer
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

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

  # Enable networking
  networking.networkmanager.enable = true;

  # Essential packages
  environment.systemPackages = with pkgs; [
    vim
    btop
    wget
    git
    psmisc # killall/pstree/...
    pciutils # lspci
    usbutils # lsusb
    tree
    rar
    p7zip
    jq
    binutils
    nix-output-monitor # nixos-rebuild wrapper
    nvd # Package version diff
    nix-tree # Browse /nix/store
  ];

  # Allow closed source packages
  nixpkgs.config.allowUnfree = true;

  # Zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Fish shell
  programs.fish.enable = true;

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