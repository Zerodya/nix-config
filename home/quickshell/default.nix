# forked from https://github.com/TLSingh1/dotfiles/tree/main/modules/wm/quickshell
{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix          # Caelestia scripts and quickshell wrapper derivations
    ./config.nix           # Configuration files and environment setup
  ];

  # Main packages
  home.packages = with pkgs; [
    config.programs.quickshell.finalPackage  # Our wrapped quickshell
    config.programs.quickshell.caelestia-scripts
    # Qt dependencies
    qt6.qt5compat
    qt6.qtdeclarative
    
    # Runtime dependencies
    hyprpaper
    imagemagick
    wl-clipboard
    fuzzel
    socat
    foot
    jq
    python3
    python3Packages.materialyoucolor
    grim
    wayfreeze
    wl-screenrec
    
    # Additional dependencies
    gtk3 # to run apps with gtk-launch
    lm_sensors
    curl
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    fd
    python3Packages.pyaudio
    python3Packages.numpy
    cava
    networkmanager
    bluez
    ddcutil
    brightnessctl
    
    # Wrapper for caelestia to work with quickshell
    (writeScriptBin "caelestia-quickshell" ''
      #!${pkgs.fish}/bin/fish
      
      # Override for caelestia commands to work with quickshell
      set -l original_caelestia ${config.programs.quickshell.caelestia-scripts}/bin/caelestia
      
      if test -n "$argv[1]"
          set -l cmd $argv[1]
          set -l args $argv[2..]
          switch $cmd
              case "shell"
                  if test -n "$args[1]"
                      set -l subcmd $args[1]
                      set -l subargs $args[2..]
                      switch $subcmd
                          case "show" "toggle"
                              if test -n "$subargs[1]"
                                  exec ${config.programs.quickshell.finalPackage}/bin/qs -c caelestia ipc call drawers $subcmd $subargs[1]
                              else
                                  echo "Usage: caelestia shell $subcmd <drawer>"
                                  exit 1
                              end
                          case "media"
                              if test -n "$subargs[1]"
                                  set -l action $subargs[1]
                                  switch $action
                                      case "play-pause"
                                          exec ${config.programs.quickshell.finalPackage}/bin/qs -c caelestia ipc call mpris playPause
                                      case '*'
                                          exec ${config.programs.quickshell.finalPackage}/bin/qs -c caelestia ipc call mpris $action
                                  end
                              else
                                  echo "Usage: caelestia shell media <action>"
                                  exit 1
                              end
                          case '*'
                              # For other shell commands, try the original
                              exec $original_caelestia $argv
                      end
                  else
                      exec $original_caelestia $argv
                  end
              case "toggle" "workspace-action" "scheme" "variant" "screenshot" "record" "clipboard" "clipboard-delete" "emoji-picker" "wallpaper" "pip"
                  # Forward these commands directly to quickshell IPC
                  exec ${config.programs.quickshell.finalPackage}/bin/qs -c caelestia ipc call $cmd $args
              case '*'
                  # For all other commands, use the original
                  exec $original_caelestia $argv
          end
      else
          exec $original_caelestia
      end
    '')
  ];

  # Systemd service
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia desktop shell";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${config.programs.quickshell.finalPackage}/bin/qs -c caelestia";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  
  # Ensure quickshell service starts before Hyprland
  systemd.user.services.hyprland = {
    Unit = {
      After = ["caelestia-shell.service"];
      Requires = ["caelestia-shell.service"];
    };
  };

  # Shell aliases
  home.shellAliases = {
    caelestia-shell = "qs -c caelestia";
    caelestia-edit = "cd ${config.xdg.configHome}/quickshell/caelestia && $EDITOR";
    caelestia = "caelestia-quickshell";
  };

}
