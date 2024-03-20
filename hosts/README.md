|  |  |
| --- | --- |
| [`eva01/`](./eva01/) | Configuration for my desktop (Ryzen 5 5600X, Radeon 6700XT, 16GB RAM) |
| [`eva02/`](./eva02/) | Configuration for my laptop (Thinkpad E15 Gen 1, i5-10210U, 16GB RAM) |

This directory contains host-specific configurations. Each host imports: 
- their system modules from `/system/modules/` in `default.nix`
- their home modules from `/home/modules/` in `home.nix`