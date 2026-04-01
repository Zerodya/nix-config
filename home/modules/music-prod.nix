{ pkgs, ... }:

let
  # Some Reapack extensions need this to work
  reaper-wrapped = pkgs.symlinkJoin {
    name = "reaper";
    paths = [ pkgs.reaper ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/reaper \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
          pkgs.gtk3 pkgs.gdk-pixbuf pkgs.libepoxy pkgs.fontconfig
          pkgs.freetype pkgs.libpng pkgs.zlib pkgs.glib pkgs.cairo
          pkgs.pango pkgs.harfbuzz pkgs.libjpeg pkgs.stdenv.cc.cc
        ]}"
    '';
  };
in

{
  home.packages = with pkgs; [
    reaper-wrapped
    
    tonelib-gfx-478

    yabridge
    yabridgectl

    neural-amp-modeler-lv2

    x42-avldrums
  ];
}