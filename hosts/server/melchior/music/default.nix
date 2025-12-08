{ lib, username, ...}:
let 
  music-dir = "/mnt/storage/music";
in 
{
  systemd.tmpfiles.rules = [
    # Set permissions for the music directory
    "d ${music-dir} 0770 ${username} music - -"
  ];

  users.groups.music.members = [ "navidrome" "slskd" ];

  services.navidrome = {
    enable = true;
    user = "navidrome";
    group = "music";

    settings = {
      Address = "0.0.0.0";
      Port = 4533;

      MusicFolder = "${music-dir}";
    };

    environmentFile = "/home/${username}/nix-config/hosts/server/melchior/music/navidrome.env";
  };

  services.slskd = {
    enable = true;
    user = "slskd";
    group = "music";

    domain = "0.0.0.0";
    settings = {
      network.address = "0.0.0.0";
      network.port = 5030;

      directories.downloads = "${music-dir}";
      shares.directories = [ "${music-dir}" ];
    };

    environmentFile = "/home/${username}/nix-config/hosts/server/melchior/music/slskd.env";
  };
  systemd.services.slskd.serviceConfig = {
    # Allow access to music directory
    ReadOnlyPaths = lib.mkForce [];
    ReadWritePaths = lib.mkForce [
      "${music-dir}"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 
      4533 # navidrome
      5030 # slskd
    ];
    allowedUDPPorts = [ 
      5030 # slskd
    ];
  };
}