# Desktop

|  |  |
| --- | --- |
| [`common/`](./common/) | Audio, bluetooth, flatpak, keyboard, packages, security and users |
| [`environment/`](./environment/) | Display manager, portals and desktop environments |

System config for desktop hosts. `common/` is imported by every desktop in [`flake.nix`](../../flake.nix), `environment/` is imported by each host's `default.nix`.