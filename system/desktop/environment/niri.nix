{ pkgs, inputs, ... }:
{
  imports = [ 
    inputs.niri.nixosModules.niri
    inputs.dms-plugin-registry.nixosModules.default
  ];


  ###########################
  #          Niri           #
  ###########################

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
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
    dmsPatched = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        f=$out/share/quickshell/dms/Modules/DankBar/Widgets/WorkspaceSwitcher.qml

        # Length along the bar
        #   active   = max(barThickness * 3.0, appIconSize * 2.5)
        #   inactive = max(barThickness * 1.5, appIconSize * 1.0)
        substituteInPlace $f \
          --replace-fail 'readonly property real activeRatio: linesStyle ? 1.6 : cardsStyle ? 0.9 : 1.05' \
                         'readonly property real activeRatio: 3.0' \
          --replace-fail 'readonly property real activeIconRatio: 1.6' \
                         'readonly property real activeIconRatio: 2.5' \
          --replace-fail 'readonly property real iconRatio: 1.2' \
                         'readonly property real iconRatio: 1.0' \
          --replace-fail 'Math.max(root.widgetThickness * root.compactRatio, root.appIconSize * root.iconRatio)' \
                         'Math.max(root.widgetThickness * 1.5, root.appIconSize * root.iconRatio)'

        # Thickness across the bar (pill style without apps, pill style with apps, and "lines" style)
        substituteInPlace $f \
          --replace-fail 'readonly property real slimRatio: 0.5' \
                         'readonly property real slimRatio: 0.22' \
          --replace-fail 'readonly property real activeSlimRatio: 0.6' \
                         'readonly property real activeSlimRatio: 0.22' \
          --replace-fail 'Math.max(widgetThickness * root.compactRatio, root.appIconSize + Theme.spacingXS * 2)' \
                         'Math.max(widgetThickness * 0.22, root.appIconSize + Theme.spacingXS * 2)' \
          --replace-fail 'readonly property real lineRatio: 0.12' \
                         'readonly property real lineRatio: 0.22' \
          --replace-fail 'readonly property real activeLineRatio: 0.2' \
                         'readonly property real activeLineRatio: 0.22'

        # Filter out unnamed dynamic workspaces (padding placeholders are kept)
        substituteInPlace $f \
          --replace-fail 'function opt(key) {' \
                         'function namedOnly(list) {
            return list.filter(ws => ws && (ws.placeholder || (ws.name && ws.name !== "")));
        }

        function opt(key) {' \
          --replace-fail 'return hyprlandSlotList(baseList);' \
                         'return hyprlandSlotList(root.namedOnly(baseList));' \
          --replace-fail 'return baseList;' \
                         'return root.namedOnly(baseList);' \
          --replace-fail 'return padWorkspaces(baseList);' \
                         'return padWorkspaces(root.namedOnly(baseList));'
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
      audioInhibit.enable = true;
      linuxWallpaperEngine.enable = true;
      mpvpaperWallpaper.enable = true;
    };
  };
}