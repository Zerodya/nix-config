# Home LAN addresses shared between hosts
{
  gateway = "192.168.1.1";
  eva01 = "192.168.1.28";
  melchior = "192.168.1.201";
  balthasar = "192.168.1.202";

  # Isolated VM lab /24 on each host (first three octets), see system/modules/vm-lab.nix
  labs = {
    melchior = "10.66.66";
    balthasar = "192.168.56"; # GOAD's ip_range
  };
}
