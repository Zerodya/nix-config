{ username, ... }:

{ 
  imports = [
    # Import all secrets modules here
    ./music/secrets.nix
  ];

  #sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt"; # without impermanence
  sops.age.keyFile = "/persist/var/lib/sops-nix/keys.txt"; # with impermanence

  # User password for server
  sops.secrets.server-password = {
    sopsFile = ../../../secrets/server-password.yaml;
    neededForUsers = true;  # Makes it available during early boot
  };

}