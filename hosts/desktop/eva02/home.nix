{
  imports = [
    ../../../home/home.nix

    # Modules
    ../../../home/modules/laptop.nix
    ../../../home/modules/music-prod.nix
        
    # Compositors extra config
    ../../../home/hyprland/eva02/extraConfig.nix
    ../../../home/niri/eva02/extraConfig.nix
  ];
}
