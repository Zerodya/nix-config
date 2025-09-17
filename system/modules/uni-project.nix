{ username, ...}:{

  virtualisation.docker = {
    enable = true;
  };
  users.users.${username}.extraGroups = [ "docker" ];

  security.apparmor = {
    enable = true;
    policies."apparmor-flask".profile = ''
      #include <tunables/global>
      profile apparmor-flask flags=(attach_disconnected,mediate_deleted) {
        capability net_bind_service,
        capability setuid,
        capability setgid,

        # Dentro al container
        /app/** r,
        /app/data.txt rw,

        /usr/** rix,
        /lib/** rix,
        /lib64/** rix,

        # Blocca tutto il resto
        deny /** w,
        deny /** mrwklx,
      }
    '';
  };


}