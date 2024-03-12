{
  pkgs,
  config,
  ...
}: {
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/hypr/autolaunch.conf".source = ./autolaunch.conf;
  home.file.".config/hypr/desktop.conf".source = ./desktop.conf;
  home.file.".config/hypr/laptop.conf".source = ./laptop.conf;

}