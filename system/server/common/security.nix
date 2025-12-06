{
  # Disable sudo
  # security.sudo.enable = false;

  # Only allow root to use the Nix package manager
  # nix.settings.allowed-users = [ "root" ];

  # Make `/nix/store` the only binaries that are allowed to be executed
  #fileSystems ={
  #  "/".options = [ "noexec" ];
  #  "/etc/nixos".options = [ "noexec" ];
  #  "/srv".options = [ "noexec" ];
  #  "/var/log".options = [ "noexec" ];
  #};

  # Limit ssh
  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    allowSFTP = false;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtTV2MdD+mP0Ukk98OKRyFWPL4kzkH4mUtOwqUUZ277 alpha@eva01"
  ];

}