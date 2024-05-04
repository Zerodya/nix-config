{ pkgs, ... }:

{
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

  environment.systemPackages = with pkgs; [
    vim
    btop
    wget
    git
    psmisc # killall/pstree/...
    pciutils # lspci
    usbutils # lsusb
  ];

   programs.fish.enable = true;

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other
  };
  virtualisation.oci-containers.backend = "podman";

}