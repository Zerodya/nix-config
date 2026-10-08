# Melchior

|  |  |
| --- | --- |
| [`beszel/`](./beszel/) | Beszel monitoring dashboard, Discord alerts for failed services |
| [`minecraft/`](./minecraft/) | Minecraft server (disabled) |
| [`music/`](./music/) | Navidrome, slskd, droppedneedle and beets import pipeline, lyrics translation |
| [`photos/`](./photos/) | Immich with Borg backups (disabled) |
| [`searx/`](./searx/) | SearXNG search engine |

ThinkCentre M720q home server. Each subdirectory is a service imported in [`default.nix`](./default.nix), with its own `secrets.nix` and `cloudflared.nix` where needed. Top-level files hold host-wide config:
- [`cloudflare.nix`](./cloudflare.nix) ~ Cloudflare tunnels for exposed services
- [`impermanence.nix`](./impermanence.nix) ~ root is wiped on boot, persisted paths live in `/persist`
- [`sops.nix`](./sops.nix) ~ sops-nix configuration
