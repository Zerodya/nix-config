{
  services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          # Taps longer than this stay plain Super (e.g. Mod+drag)
          global.overload_tap_timeout = 200;
          main = {
            capslock = "backspace";
            # Tap Super alone -> Mod+backspace (niri overview)
            leftmeta = "overload(meta, M-backspace)";
          };
        };
      };
    };

}
