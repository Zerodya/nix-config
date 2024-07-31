{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Better Neofetch
    fastfetch
    
    # Run executable in FHS env.
    steam-run 

    # Monitor
    ddcutil  

    # Android
    scrcpy
  ];
}