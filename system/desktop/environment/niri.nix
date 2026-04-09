{ pkgs, inputs, ... }:

{
  imports = [ inputs.niri.nixosModules.niri ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  
  # Polkit authentication agent
  security.polkit.enable = true;

  # Portal setup
  xdg.portal = {
    config.niri = {
      default = ["gnome" "gtk"];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
  
  # Environment for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Binary cache for niri
  nix.settings = {
    substituters = [ 
      "https://niri.cachix.org" 
    ];
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # DankMaterialShell
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = false;
      restartIfChanged = true;
    };

    # Core features
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };
}