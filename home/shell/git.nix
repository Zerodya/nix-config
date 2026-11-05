{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name  = "Zerodya";
      email = "nicola.pagliuca@protonmail.com";
    };
    # `gh auth setup-git` writes a store path to ~/.gitconfig that breaks after gc
    settings.credential."https://github.com".helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
    signing.format = null;
  };

  home.packages = with pkgs; [
    gh
  ];
}