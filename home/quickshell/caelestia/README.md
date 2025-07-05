This directory is a git subtree from `caelestia-dots` [shell@c214b3c](https://github.com/caelestia-dots/shell/tree/c214b3c5d6cf48ed719e9c13a4f5bda4dc7ad107) which I have slightly modified.

To update `caelestia` I run the following command inside `~/nix-config/`, and merge my changes:
```sh
git fetch ax-shell
git subtree pull \
    --prefix=home/quickshell/caelestia \
    caelestia main \
    --squash
```
## Some of my changes:
- Workspaces tweaks:
  - Pill-shaped workspaces with dynamic sizes
  - Just 6 workspaces
- Removed window preview widget from bar
- Removed gif from logout widget

## TODO
- App launcher: Order by most used apps instead of just alphabetically
- Fix or remove workspaces tab in overview widget
