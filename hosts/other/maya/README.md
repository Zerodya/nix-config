# Maya
> ### The subtle but resourceful systems operator
Minimal rescue system meant to be run from a live USB to help troubleshooting problems.

## Features
- Access via SSH - no external monitor or keyboard required
- Common troubleshooting tools installed and ready to use
- Helpful fish functions

## Build

1. Build the ISO:
```
nix build ~/nix-config#nixosConfigurations.maya.config.system.build.isoImage
```

2. Image will be in `results/iso`. Copy it to a Ventoy USB or flash it directly.