{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    functions = {
      nixos-rebuild = "sudo nixos-rebuild $argv &| nom && printf '\\n' && nvd diff (ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2);";
    };
  };

  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

}