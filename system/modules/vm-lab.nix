# Isolated libvirt lab: VMs reach only each other and eva01 (plus the internet when enabled), never the LAN or the host.
# Its /24 comes from `labs.<hostname>` in hosts/lan.nix, eva01 routes to it through this host.
# Manage VMs from eva01: virt-manager -> File -> Add Connection -> qemu+ssh://<host>/system
{ config, pkgs, lib, inputs, username, ... }:

let
  cfg = config.vmLab;
  lan = import ../../hosts/lan.nix;
  subnet = lan.labs.${config.networking.hostName};
  bridge = "vulnbr0";
  images = "/var/lib/libvirt/images";

  nixvirt = inputs.NixVirt.lib;
  # Stable UUID per VM name, so VMs only need a name
  uuid = name: let h = builtins.hashString "md5" name; s = builtins.substring; in
    "${s 0 8 h}-${s 8 4 h}-${s 12 4 h}-${s 16 4 h}-${s 20 12 h}";

  # VulnHub box: extract the .ova (tar xf) and convert its .vmdk to ${images}/<name>.qcow2
  # (nix shell nixpkgs#qemu-utils -c qemu-img convert -O qcow2 box.vmdk <name>.qcow2)
  vulnhub = name: lib.recursiveUpdate (nixvirt.domain.templates.linux {
    inherit name;
    uuid = uuid name;
    memory = { count = 1; unit = "GiB"; };
    storage_vol = "${images}/${name}.qcow2";
    virtio_drive = false; # old VulnHub kernels may lack virtio-blk
    bridge_name = bridge;
  }) { devices.interface.model.type = "e1000"; }; # and virtio-net, which the template forces

  # Windows Server 2019 evaluation ISO at ${images}/win2019.iso, disk created on first rebuild
  windows = name: ram: nixvirt.domain.templates.windows {
    inherit name;
    uuid = uuid name;
    memory = { count = ram; unit = "GiB"; };
    storage_vol = { pool = "default"; volume = "${name}.qcow2"; };
    install_vol = "${images}/win2019.iso"; # mandatory at boot, keep it around
    nvram_path = "/var/lib/libvirt/qemu/nvram/${name}_VARS.fd";
    bridge_name = bridge;
  };
in
{
  imports = [ inputs.NixVirt.nixosModules.default ];

  options.vmLab = with lib; {
    internet = mkEnableOption "lab access to the internet (never the LAN), e.g. while GOAD provisions Windows";
    autostart = mkEnableOption "starting every VM at boot, instead of from virt-manager";
    uplink = mkOption { type = types.str; default = "eno1"; description = "Host interface towards the router"; };
    # VMs not listed are undefined by NixVirt on rebuild (their disks are kept)
    vulnhubBoxes = mkOption { type = types.listOf types.str; default = [ ]; };
    windowsVms = mkOption { type = types.attrsOf types.int; default = { }; description = "Windows VM name -> RAM in GiB"; };
  };

  config = {
    virtualisation.libvirt = {
      enable = true; # also enables libvirtd
      swtpm.enable = true; # the Windows template adds a TPM 2.0 device
      connections."qemu:///system" = {
        networks = [{
          # "open" = libvirt adds no firewall rules, routing is controlled by the rules below. No DNS so nothing leaks through the host resolver.
          definition = pkgs.writeText "vulnhub.xml" ''
            <network>
              <name>vulnhub</name>
              <uuid>34d4bc44-7305-48c5-a687-8d5d503dc799</uuid>
              <forward mode="open"/>
              <bridge name="${bridge}" stp="on" delay="0"/>
              <dns enable="no"/>
              <ip address="${subnet}.1" netmask="255.255.255.0">
                <dhcp><range start="${subnet}.100" end="${subnet}.254"/></dhcp>
              </ip>
            </network>
          '';
          active = true;
        }];
        pools = [{
          definition = nixvirt.pool.writeXML {
            name = "default";
            uuid = uuid "default";
            type = "dir";
            target.path = images;
          };
          active = true;
          volumes = map (name: {
            definition = nixvirt.volume.writeXML {
              name = "${name}.qcow2";
              capacity = { count = 60; unit = "GiB"; };
              target.format.type = "qcow2";
            };
          }) (lib.attrNames cfg.windowsVms); # VulnHub disks are imported, not created
        }];
        domains = map (vm: {
          definition = nixvirt.domain.writeXML vm;
          active = if cfg.autostart then true else null; # null = started and stopped from virt-manager
        }) (map vulnhub cfg.vulnhubBoxes ++ lib.mapAttrsToList windows cfg.windowsVms);
      };
    };
    virtualisation.libvirtd = {
      qemu.runAsRoot = false; # a VM escape lands as qemu-libvirtd, not root
      # A (nightly) reboot powers VMs off, only autostart brings them back
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    # Pool directory must exist before NixVirt defines the pool (/var/lib/libvirt may start empty, e.g. with impermanence)
    systemd.tmpfiles.rules = [ "d ${images} 0711 root root -" ];
    systemd.services.nixvirt.after = [ "systemd-tmpfiles-setup.service" "systemd-tmpfiles-resetup.service" ];

    users.users.${username}.extraGroups = [ "libvirtd" ];
    environment.systemPackages = [ pkgs.netcat ]; # virt-manager tunnels the VM console through `nc` over ssh

    boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

    networking.firewall.extraCommands = ''
      # VMs may only reach the host for DHCP, not host services (e.g. ports opened on every interface)
      ip46tables -I nixos-fw -i ${bridge} -j nixos-fw-refuse
      iptables -I nixos-fw -i ${bridge} -p udp --dport 67 -j nixos-fw-accept

      # Routed traffic: eva01 <-> lab only, plus internet when enabled
      iptables -N vulnhub-fwd 2>/dev/null || iptables -F vulnhub-fwd
      iptables -C FORWARD -j vulnhub-fwd 2>/dev/null || iptables -I FORWARD -j vulnhub-fwd
      iptables -A vulnhub-fwd -i ${bridge} -d ${lan.eva01} -j ACCEPT
      iptables -A vulnhub-fwd -o ${bridge} -s ${lan.eva01} -j ACCEPT
      ${lib.optionalString cfg.internet ''
        iptables -A vulnhub-fwd -o ${bridge} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        for net in 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 100.64.0.0/10 169.254.0.0/16; do
          iptables -A vulnhub-fwd -i ${bridge} -d $net -j DROP
        done
        iptables -A vulnhub-fwd -i ${bridge} -o ${cfg.uplink} -j ACCEPT
      ''}
      iptables -A vulnhub-fwd -i ${bridge} -j DROP
      iptables -A vulnhub-fwd -o ${bridge} -j DROP

      iptables -t nat -N vulnhub-nat 2>/dev/null || iptables -t nat -F vulnhub-nat
      iptables -t nat -C POSTROUTING -j vulnhub-nat 2>/dev/null || iptables -t nat -I POSTROUTING -j vulnhub-nat
      ${lib.optionalString cfg.internet "iptables -t nat -A vulnhub-nat -s ${subnet}.0/24 -o ${cfg.uplink} ! -d 192.168.0.0/16 -j MASQUERADE"}
    '';
  };
}
