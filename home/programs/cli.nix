{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fetch
    fastfetch

    # Nix language server
    nixd
    
    # Run executable in FHS env.
    steam-run

    # Monitor
    ddcutil  

    # Android
    scrcpy
  ];
}