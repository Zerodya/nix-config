# Hosts

|  |  |
| --- | --- |
| [`desktop/`](./desktop/) | Desktop and laptop |
| [`server/`](./server/) | Home servers |
| [`other/`](./other/) | Anything else, like the recovery ISO |

This directory contains host-specific configurations. Each host is defined in [`flake.nix`](../flake.nix) and has:
- `default.nix` ~ system config, imports system modules from [`/system/`](../system/)
- `home.nix` ~ Home-Manager config, imports home modules from [`/home/`](../home/)
- `hardware-configuration.nix` ~ generated hardware config
