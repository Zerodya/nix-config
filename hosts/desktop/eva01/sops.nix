{ config, username, ... }:

{
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt"; # without impermanence

  # GitHub token for flake updates (avoids API rate limit)
  sops.secrets.nix-access-tokens = {
    sopsFile = ../../../secrets/nix-access-tokens.yaml;
    owner = username; # nix flake update runs as the user
  };

  # "!include" skips the file if it's missing (before first activation)
  nix.extraOptions = ''
    !include ${config.sops.secrets.nix-access-tokens.path}
  '';
}
