{ pkgs, ... }:

{
  home.packages = with pkgs; [
    reaper
    
    tonelib-gfx-478

    yabridge
    yabridgectl

    neural-amp-modeler-lv2

    x42-avldrums
  ];
}