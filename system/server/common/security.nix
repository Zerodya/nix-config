{ username, ... }:
{
  # Sudo hardening
  security.sudo.execWheelOnly = true;

  # Only allow root to use the Nix package manager
  # nix.settings.allowed-users = [ "root" ];

  # Make `/nix/store` the only binaries that are allowed to be executed
  #fileSystems ={
  #  "/".options = [ "noexec" ];
  #  "/etc/nixos".options = [ "noexec" ];
  #  "/srv".options = [ "noexec" ];
  #  "/var/log".options = [ "noexec" ];
  #};

  # SSH hardening
  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "${username}" ];
    };
    allowSFTP = true;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };
  users.users.${username}.openssh.authorizedKeys.keys = [
    # Generate a public key in each host: `ssh-keygen -t ed25519 -f ~/.ssh/id_SERVERNAME`
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtTV2MdD+mP0Ukk98OKRyFWPL4kzkH4mUtOwqUUZ277 alpha@eva01" # Desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwgs9nKpLG60t+AMXQ0R57NAWGaYtKMua+/mO8KNAV9 u0_a235@localhost" # Phone
  ];

  #services.fail2ban.enable = true;

}