{ username, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    functions = {
      eva-rebuild = {
        # Assumes flake is located in ~/nix-config/
        body = ''
          if test (count $argv) -lt 2
              echo "Usage: eva-rebuild <nixos-rebuild-arg> <system-name> [custom arguments...]"
              return 1
          end

          set rebuild_arg $argv[1]
          set system_name $argv[2]

          # Capture any extra custom arguments, if provided.
          set custom_args
          if test (count $argv) -gt 2
              set custom_args $argv[3..-1]
          end

          sudo nixos-rebuild $rebuild_arg --flake "/home/${username}/nix-config/#$system_name" $custom_args -L &| nom
          and printf '\\n'
          and nvd diff (ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)
        '';
      };

      eva-update = {
        # Assumes flake is located in ~/nix-config/
        body = ''
          if test (count $argv) -ne 2
              echo "Usage: eva-update <nixos-rebuild-arg> <system-name>"
              return 1
          end

          set rebuild_arg $argv[1]
          set system_name $argv[2]

          sudo nix flake update --flake '/home/${username}/nix-config/'
          and eva-rebuild $rebuild_arg $system_name
        '';
      };

      eva-remote-rebuild = {
        # Assumes flake is located in ~/nix-config/
        body = ''
          if test (count $argv) -lt 2
              echo "Usage: eva-remote-rebuild <nixos-rebuild-arg> <system-name> [--locally] [custom arguments...]"
              return 1
          end

          set rebuild_arg $argv[1]
          set system_name $argv[2]

          # Parse remaining arguments, detect --locally, and collect custom args.
          set locally 0
          set custom_args
          if test (count $argv) -gt 2
              for a in $argv[3..-1]
                  if test "$a" = "--locally"
                      set locally 1
                  else
                      set custom_args $custom_args $a
                  end
              end
          end

          # Build the command: include --build-host $system_name unless --locally was requested.
          if test $locally -eq 1
              nixos-rebuild $rebuild_arg -S --flake "/home/${username}/nix-config/#$system_name" --target-host $system_name $custom_args -L &| nom
          else
              nixos-rebuild $rebuild_arg -S --flake "/home/${username}/nix-config/#$system_name" --target-host $system_name --build-host $system_name $custom_args -L &| nom
          end

          # Print newline, then show the diff on the target host (where profiles changed).
          and printf '\\n'
          and ssh $system_name -- 'nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)'
        '';
      };

      eva-cleanup = {
        body = ''
          # Cleanup nix-flatpak
          sudo rm -rf /var/lib/flatpak/.module/trash

          # Remove result symlinks to derivations if present
          rm -f /home/${username}/result

          sudo nix-collect-garbage -d # as root - NixOS system
          nix-collect-garbage -d      # as user - home-manager
        '';
      };

      eva-deletegen = {
        # Delete specific NixOS generations
        body = ''
          # List generations
          sudo nix-env -p /nix/var/nix/profiles/system --list-generations

          # Prompt user for generations to delete
          echo "Enter the generation numbers to delete:"
          read generations

          # Check if user provided input
          if test -z "$generations"
              echo "No generations specified. Aborting."
              return 1
          end

          # Run garbage collection to delete specified generations
          sudo nix-collect-garbage --delete-generations $generations
        '';
      };

      eva-derivate = {
        # Assumes flake is located in ~/nix-config/
        body = ''
          if test (count $argv) -lt 1
              echo "Usage: eva-derivate <system-name>"
              return 1
          end

          set system_name $argv[1]

          nix path-info --derivation "/home/${username}/nix-config/#nixosConfigurations.$system_name.config.system.build.toplevel"
        '';
      };

      # Alias `nix-shell -p` to `,`
      "," = {
        body = ''
          if test (count $argv) -eq 0
              echo "Usage: , <packages> --command <command>"
              return 1
          end

          nix-shell -p $argv
        '';
      };
    };
  };
  
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  
}