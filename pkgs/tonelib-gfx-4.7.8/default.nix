{ pkgs }:

let
  src = pkgs.fetchurl {
    url = "https://github.com/Zerodya/nix-binaries/releases/download/tl-gfx-4.7.8/bundle.tar.gz";
    sha256 = "sha256-/yO07CD6uxbBVAvTIJfuCGvJOF+85cEq51n/1Q1wlIA=";
  };
in
pkgs.runCommand "tonelib-gfx-4.7.8"
  {
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-GRM8Be5hq71UklfrUC0EQYuzH/Aspkd9/4vXRmvJ5qY=";
  }
  ''
    mkdir -p $out
    tar xzf ${src} -C $out
  ''