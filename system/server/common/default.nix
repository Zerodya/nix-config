{ ... }:

{
  imports = [
    ./users.nix
  ];

  # Nix Store
  nix.gc = {
    automatic = true;
    dates = "03:00";
    options = "--delete-older-than 4d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "03:30" ];
  };

}