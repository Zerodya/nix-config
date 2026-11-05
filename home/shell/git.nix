{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name  = "Zerodya";
      email = "nicola.pagliuca@protonmail.com";
    };
    signing.format = null;
  };

  home.packages = with pkgs; [
    gh
  ];
}