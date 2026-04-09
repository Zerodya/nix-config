{
  imports = [
    ./autorun.nix
  ];

  programs.niri.settings = {
    # Output configuration
    outputs."DP-1" = {
      mode = {
        width = 2560;
        height = 1440;
        refresh = 164.998;
      };
      variable-refresh-rate = "on-demand";
    };
  };
}