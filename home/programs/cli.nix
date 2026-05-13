{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Stats
    btop-rocm
    fastfetch

    # Suspend programs
    wl-freeze

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