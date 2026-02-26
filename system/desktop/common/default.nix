{ username, ... }:

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

  # Cache
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
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

  # NetworkManager
  networking.networkmanager.enable = true;
  
  # Zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enable SSD TRIM timer https://www.reddit.com/r/NixOS/comments/rbzhb1/if_you_have_a_ssd_dont_forget_to_enable_fstrim/
  services.fstrim.enable = true;

  # SSH aliases for my servers
  programs.ssh = {
    extraConfig = ''
      Host melchior
        HostName 192.168.1.201
        Port 5432
        User ${username}
        IdentityFile ~/.ssh/id_melchior
        IdentitiesOnly yes

      Host maya
        HostName 192.168.1.250
        Port 22
        User root
        IdentityFile ~/.ssh/id_maya
        IdentitiesOnly yes
    '';
  };
}

