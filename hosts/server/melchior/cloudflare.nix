{ pkgs, ... }:

{
  imports = [
    # Tunnels
    ./music/cloudflared.nix
  ];

  services.cloudflared.enable = true;

  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  # Larger UDP socket buffer for Cloudflare
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };
}