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
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/hypr/autolaunch.conf".source = ./autolaunch.conf;
  home.file.".config/hypr/desktop.conf".source = ./desktop.conf;
  home.file.".config/hypr/laptop.conf".source = ./laptop.conf;

}