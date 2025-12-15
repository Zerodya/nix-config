{ username, ... }:

{ 
  imports = [
    # Import all secrets modules here
    ./music/secrets.nix
  ];

  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
}