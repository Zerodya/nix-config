{ pkgs, inputs, ... }:
{
  imports = [ 
    inputs.niri.nixosModules.niri
    inputs.dms-plugin-registry.modules.default
  ];


  ###########################
  #          Niri           #
  ###########################

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  # Use niri-unstable from cache
  programs.niri = 
    let
      niriPkgs = inputs.niri-pkgs.packages.${pkgs.stdenv.hostPlatform.system};
    in
  {
    enable = true;
    package = niriPkgs.niri-unstable;
  };

  # Binary cache
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
  };

  # Portal setup
  xdg.portal = {
    config.niri.default = ["gnome" "gtk"];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Disable Niri polkit (will use DankMaterialShell polkit instead)
  security.polkit.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;
  
  # Environment for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  ###########################
  #    DankMaterialShell    #
  ###########################

  programs.dms-shell = 
    let
      # Patch dms flake package
      dmsPatched = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          # Line 1 == Height for Active workspace and Active appIconSize
          # Line 2 == Height for Inactive workspace and Inactive appIconSize
          # Line 3 == Width for no apps
          # Line 4 == Width for apps
          substituteInPlace $out/share/quickshell/dms/Modules/DankBar/Widgets/WorkspaceSwitcher.qml \
            --replace 'Math.max(root.widgetHeight * 1.05, root.appIconSize * 1.6)' 'Math.max(root.widgetHeight * 3.0, root.appIconSize * 2.5)' \
            --replace 'Math.max(root.widgetHeight * 0.7, root.appIconSize * 1.2)' 'Math.max(root.widgetHeight * 1.5, root.appIconSize * 1.0)' \
            --replace 'widgetHeight * 0.5' 'widgetHeight * 0.22' \
            --replace 'widgetHeight * 0.7' 'widgetHeight * 0.22'

          # Filter out unnamed dynamic workspaces
          substituteInPlace $out/share/quickshell/dms/Modules/DankBar/Widgets/WorkspaceSwitcher.qml \
            --replace 'workspaces = workspaces.slice().sort((a, b) => a.idx - b.idx);' 'workspaces = workspaces.filter(ws => ws.name && ws.name !== "").slice().sort((a, b) => a.idx - b.idx);'
        '';
      });
    in  
  {
    enable = true;
    systemd.enable = false;

    # Patched shell
    package = dmsPatched;

    # Latest quickshell
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
    
    # Plugins
    plugins = {
      dankActions.enable = true;
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