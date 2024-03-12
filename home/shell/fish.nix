{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  programs.fish.functions = {
      nixos-rebuild = "sudo nixos-rebuild $argv &| nom && printf '\\n' && nvd diff (ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2);";
  };

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

}