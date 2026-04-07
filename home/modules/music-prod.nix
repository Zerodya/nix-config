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

  # Plugins that should be discoverable automatically by DAWs
  musicPlugins = with pkgs; [
    tonelib-gfx-478
    
    adlplug
    lsp-plugins
    odin2
    geonkick
    drumkv1
    cardinal
    distrho-ports
    vital
    x42-avldrums
    neural-amp-modeler-lv2
    hydrogen
  ];

  # Filter plugins by format
  hasVst3 = p: builtins.pathExists "${p}/lib/vst3";
  hasLv2 = p: builtins.pathExists "${p}/lib/lv2";
  hasVst = p: builtins.pathExists "${p}/lib/vst";
  
  # Merge all plugins of each type into single directories
  myVst3 = pkgs.symlinkJoin {
    name = "my-vst3-plugins";
    paths = builtins.filter hasVst3 musicPlugins;
  };
  myLv2 = pkgs.symlinkJoin {
    name = "my-lv2-plugins";
    paths = builtins.filter hasLv2 musicPlugins;
  };
  myVst = pkgs.symlinkJoin {
    name = "my-vst-plugins";
    paths = builtins.filter hasVst musicPlugins;
  };
in

{
  home.packages = musicPlugins ++ [
    # DAW
    reaper-wrapped

    # Yabridge
    pkgs.yabridge
    pkgs.yabridgectl
  ];

  # Symlink merged directories to standard locations
  home.file.".vst3" = {
    source = "${myVst3}/lib/vst3";
    recursive = true;
  };
  home.file.".lv2" = {
    source = "${myLv2}/lib/lv2";
    recursive = true;
  };
  home.file.".vst" = {
    source = "${myVst}/lib/vst";
    recursive = true;
  };
}