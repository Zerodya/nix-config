# System

|  |  |
| --- | --- |
| [`core/`](./core/) | Base config shared by every host (nix, locale, boot) |
| [`desktop/`](./desktop/) | Config shared by desktop hosts |
| [`server/`](./server/) | Config shared by server hosts |
| [`modules/`](./modules/) | Optional modules that hosts import in their `default.nix` |

This directory contains the NixOS system configuration. Every host gets `core/` plus either `desktop/` or `server/` from [`flake.nix`](../flake.nix), then picks what it needs from `modules/`.
