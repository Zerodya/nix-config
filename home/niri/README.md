# Niri

|  |  |
| --- | --- |
| [`eva01/`](./eva01/) | Desktop outputs, layout and autorun |
| [`eva02/`](./eva02/) | Laptop outputs, layout and autorun |

Niri config shared by every host, written with niri-flake. [`autorun.nix`](./autorun.nix) starts the shell and background apps. Each host imports its own `extraConfig.nix` in its `home.nix`.
