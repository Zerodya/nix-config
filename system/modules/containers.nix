{ pkgs, ... }:

{
  virtualisation.containers.enable = true; # Enable common container config files in /etc/containers
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };
  environment.systemPackages = with pkgs; [
    dive            # look into docker image layers
    podman-tui      # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose  # start group of containers for dev
  ];
}