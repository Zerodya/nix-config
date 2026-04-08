{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Stats
    btop-rocm
    fastfetch

    # Nix language server
    nil
    nixfmt
    
    # Run executable in FHS env.
    steam-run

    # Monitor
    ddcutil  

    # Android
    scrcpy
  ];
}