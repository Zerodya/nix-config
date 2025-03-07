{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./flatpak.nix
    ./keyboard.nix
    ./packages.nix
    ./security.nix
    ./stylix.nix
    ./users.nix
    ./virtualization.nix
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

  # Nix Store
  nix.gc = {
    automatic = true;
    dates = "12:00";
    options = "--delete-older-than 14d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "12:30" ];
  };
  
  # Zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enable SSD TRIM timer https://www.reddit.com/r/NixOS/comments/rbzhb1/if_you_have_a_ssd_dont_forget_to_enable_fstrim/
  services.fstrim.enable = true;
}

