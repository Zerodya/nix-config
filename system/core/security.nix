{ pkgs, ... }:

{
  # Enable polkit
  security.polkit.enable = true;

  # Start Gnome Polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "Polkit GNOME authentication agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Don't ask for password when starting CoreCtrl
  security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if ((action.id == "org.corectrl.helper.init" ||
               action.id == "org.corectrl.helperkiller.init") &&
              subject.local == true &&
              subject.active == true &&
              subject.isInGroup("wheel")) {
                  return polkit.Result.YES;
          }
      });
    ''; 
  
  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true; # automatically unlock the user’s default Gnome keyring upon login
}