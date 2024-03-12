{ inputs, pkgs, username, ... }:
{
  imports = [ 
    inputs.ags.homeManagerModules.default
    inputs.matugen.nixosModules.default
  ];

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    configDir = null;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  programs.matugen = {
    enable = true;
  };

  # TODO add AGS files and source them
}