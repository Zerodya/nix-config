# https://github.com/HeyImKyu/fabric-flakes-example/blob/main/modules/home-manager/fabric/default.nix

{ config, pkgs, ... }:

{
  home.file."${config.xdg.configHome}/Ax-Shell" = {
    source = ./ax-shell;
    recursive = true;
  };

  home.file.".local/share/fonts/tabler-icons.ttf" = {
    source = ./ax-shell/assets/fonts/tabler-icons/tabler-icons.ttf;
  };

  home.file."${config.xdg.configHome}/matugen/config.toml" = {
    source = ./matugen.toml;
  };

  home.packages = with pkgs; [
    matugen
    cava
    hyprsunset
    hyprpicker
    gpu-screen-recorder
    wlinhibit
    tesseract
    imagemagick
    nvtopPackages.full   
    nur.repos.HeyImKyu.fabric-cli
    (nur.repos.HeyImKyu.run-widget.override {
      extraPythonPackages = with python3Packages; [
        ijson
        pillow
        psutil
        requests
        setproctitle
        toml
        watchdog
        thefuzz
        numpy
        chardet
      ];
      extraBuildInputs = [
        nur.repos.HeyImKyu.fabric-gray
        networkmanager
        networkmanager.dev
        playerctl
      ];
    })
  ];
  

  wayland.windowManager.hyprland.settings.layerrule = [
    "noanim, fabric"
  ];
}