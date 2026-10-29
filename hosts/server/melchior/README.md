# Melchior

|  |  |
| --- | --- |
| [`beszel/`](./beszel/) | Beszel monitoring dashboard, Discord alerts for failed services |
| [`degoog/`](./degoog/) | Degoog search engine aggregator |
| [`minecraft/`](./minecraft/) | Minecraft server (disabled) |
| [`music/`](./music/) | Navidrome, slskd, droppedneedle and beets import pipeline, lyrics translation |
| [`photos/`](./photos/) | Immich, reachable over Tailscale and the LAN, Borg backups to the external disk |

ThinkCentre M720q home server. Each subdirectory is a service imported in [`default.nix`](./default.nix), with its own `secrets.nix` and `cloudflared.nix` where needed. Top-level files hold host-wide config:
- [`cloudflare.nix`](./cloudflare.nix) ~ Cloudflare tunnels for exposed services
- [`tailscale.nix`](./tailscale.nix) ~ Tailscale for private services (Immich)
- [`impermanence.nix`](./impermanence.nix) ~ root is wiped on boot, persisted paths live in `/persist`
- [`sops.nix`](./sops.nix) ~ sops-nix configuration
