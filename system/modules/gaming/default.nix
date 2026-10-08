{pkgs, ...}:

{
  # Steam
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
      };
    };
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Steam Controller
  hardware.steam-hardware.enable = true;
  #programs.steam.extest.enable = true;

}
