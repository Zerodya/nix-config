{
  # Disable sudo
  security.sudo.enable = false;

  # Only allow root to use the Nix package manager
  nix.settings.allowed-users = [ "root" ];

  # Make `/nix/store` the only binaries that are allowed to be executed
  #fileSystems ={
  #  "/".options = [ "noexec" ];
  #  "/etc/nixos".options = [ "noexec" ];
  #  "/srv".options = [ "noexec" ];
  #  "/var/log".options = [ "noexec" ];
  #};

  # Limit ssh
  services.openssh = {
    settings.PasswordAuthentication = false;
    allowSFTP = false;
    kbdInteractiveAuthentication = false;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

}