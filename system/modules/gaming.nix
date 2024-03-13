{pkgs, ...}:

{
  # Programs
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries = (pkgs: with pkgs; [
        gamemode
      ]);
    };
    gamescopeSession.enable = true;
    #remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;
  
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
    gpuOverclock.ppfeaturemask = "0xffffffff";
  };

}