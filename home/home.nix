{ pkgs, username, ... }:
{
  imports = [
    # Core
    ./firefox
    ./kitty
    ./programs
    ./scripts
    ./shell

    # Environment
    ./caelestia-shell
    ./hyprland
    ./wallpapers
  ];
  
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;

  # Profile icon
  home.file.".face".source = ./.face;

  # GTK
  gtk = {
    enable = true;

    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };

  systemd.user.sessionVariables = {
    # Fix some gsettings errors (like apps crashing when trying to open the file chooser. Just a band-aid... still need to properly fix this)
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}/glib-2.0/schemas:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}/glib-2.0/schemas";

    # Wayland for Electron apps
    NIXOS_OZONE_WL = "1";
  };

}