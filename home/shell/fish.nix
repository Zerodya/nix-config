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
          if test (count $argv) -ne 2
              echo "Usage: eva-rebuild <nixos-rebuild-arg> <system-name>"
              return 1
          end

          set rebuild_arg $argv[1]
          set system_name $argv[2]

          sudo nixos-rebuild $rebuild_arg --flake "nix-config/#$system_name" &| nom
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

          sudo nix flake update 'nix-config/'
          and eva-rebuild $rebuild_arg $system_name
        '';
      };

      eva-cleanup = {
        body = ''
          sudo nix-collect-garbage -d && sudo nix-store --optimise
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
    };
  };
  
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  
}