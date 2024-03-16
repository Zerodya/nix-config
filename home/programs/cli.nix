{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Better Neofetch
    fastfetch

    # Nix
    nix-output-monitor # nixos-rebuild wrapper
    nvd # Package version diff
    nix-tree # Browse /nix/store
    steam-run # Run executable in FHS env.

    # Monitor
    ddcutil  

    # Android
    scrcpy
  ];
}