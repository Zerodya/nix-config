{ pkgs, inputs, ... }:

let
  # Site source lives in github:Zerodya/zerodya.net
  # Publish: push to the blog repo, then `nix flake update blog` and rebuild
  site = pkgs.runCommand "zerodya.net" {
    nativeBuildInputs = [ pkgs.zola pkgs.cacert ]; # zola needs CA certs even offline
    TZDIR = "${pkgs.tzdata}/share/zoneinfo"; # for the theme's post timezone
  } ''
    cd ${inputs.blog}
    zola build -o $out
  '';
in
{
  services.nginx = {
    enable = true;
    virtualHosts."zerodya.net" = {
      listen = [{ addr = "127.0.0.1"; port = 8095; }];
      root = site;
      extraConfig = "error_page 404 /404.html;";
    };
  };
}
