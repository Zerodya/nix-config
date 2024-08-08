{ pkgs, ... }:
{
  imports = [
    ../../../home/home.nix
    
    # Modules
    ../../../home/modules/gaming.nix
    
    # Hyprland extra config
    ../../../home/hyprland/eva01/extraConfig.nix
  ];

  home.packages = with pkgs; [
    btrfs-assistant
  ];
}
