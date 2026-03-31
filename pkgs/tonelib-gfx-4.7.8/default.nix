{ pkgs, ... }:

pkgs.runCommand "tonelib-gfx-4.7.8"
  {
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-GRM8Be5hq71UklfrUC0EQYuzH/Aspkd9/4vXRmvJ5qY=";
  }
  ''
    mkdir -p $out
    ${pkgs.curl}/bin/curl -L \
      "https://github.com/Zerodya/nix-binaries/releases/download/tl-gfx-4.7.8/bundle.tar.gz" | \
      ${pkgs.gnutar}/bin/tar xz -C $out
  ''