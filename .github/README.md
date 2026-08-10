<h1 align="center">
      <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="96px" height="96px" />
  
  Zerodya's Nix Config

  (WIP)
</h1>
</div>

This repository contains the NixOS configuration for my Desktop, Laptop, Servers, and even for a live USB recovery ISO.

> This repo is costantly changing and evolving.\
I cannot guarantee that it will work on any machine but my own.\
You shouldn't blindly build this repo on your machine. \
However, feel free to steal anything you find useful.

## Content
The main config is structured in 3 directories:
- 💾 **[system](/system)** ~ contains the NixOS system configurations
- 🏠 **[home](/home)** ~ contains my dotfiles and the Home-Manager user configurations
- 💻 **[hosts](/hosts)** ~ contains host-specific configurations; each host imports their own system and home modules from the directories above

Other directories:
- 🔒 **[secrets](/secrets)** ~ contains encrypted sops-nix secrets
- 📦 **[pkgs](/pkgs)** ~ contains personal packages not available in nixpkgs

You can find more info inside each repository.

> TODO: Update all READMEs. Documentation in this repo is *VERY* outdated.

## Screenshots
<img width="2560" height="1440" alt="niri" src="https://github.com/user-attachments/assets/6f7b21e0-84d1-4f71-a781-0a69c2d99752" />


