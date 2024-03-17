{ pkgs, ...}: {

  # Extra packages
  home.packages = with pkgs; [
    hyprshot # Screenshot tool
    swww # Wallpaper
    swaylock-effects # Lockscreen
    swayidle # Idle deamon
    wl-clip-persist # Persist clipboard
    wlr-randr # Wayland RandR
    wl-gammarelay-rs # Night light
  ];
  
  # Configuration
  home.file.".config/hypr" = {
     source = ../hyprland;
     recursive = true;
  };

}