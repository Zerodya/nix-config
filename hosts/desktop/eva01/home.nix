{
  imports = [
    ../../../home/home.nix
    
    # Modules
    ../../../home/modules/gaming-software.nix
    ../../../home/modules/infosec.nix
    ../../../home/modules/music-prod.nix
    
    # Compositors extra config
    ../../../home/hyprland/eva01/extraConfig.nix
    ../../../home/niri/eva01/extraConfig.nix
  ];
}
