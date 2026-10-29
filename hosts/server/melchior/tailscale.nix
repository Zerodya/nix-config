{ ... }:

{
  # Private access to services that should not go through Cloudflare (Immich)
  # First boot: `sudo tailscale up`, then share this machine with other users from the admin console
  services.tailscale = {
    enable = true;
    openFirewall = true; # UDP 41641 for direct connections instead of DERP relays
  };
}
