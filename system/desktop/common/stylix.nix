{pkgs, ...}: {
  # Stylix 
  # TODO add comments for the remaining colors
  stylix = {
    base16Scheme ={
      base00 = "0c0e0f"; # black
      base01 = "ee5396";
      base02 = "08bdba"; # yellow 2
      base03 = "25be6a";
      base04 = "78a9ff";
      base05 = "dfdfe0"; # white
      base06 = "c8a5ff";
      base07 = "dfdfe0";
      base08 = "ee5396"; # red
      base09 = "f16da6";
      base0A = "2dc7c4"; # yellow
      base0B = "46c880"; # green
      base0C = "33b1ff"; # cyan
      base0D = "78a9ff"; # blue
      base0E = "be95ff"; # purple
      base0F = "be95ff";
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.fira-code-nerdfont;
        name = "FiraCode Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}