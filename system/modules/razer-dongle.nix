# Module for correctly handling USB dongle behaviour of my Razer Barracuda X headphones
{
  systemd.services.disable-razer-dongle-wakeup = {
    description = "Disable XHC0 USB wake from suspend (this prevents the system waking up shortly after being suspended)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "/bin/sh -c 'echo XHC0 > /proc/acpi/wakeup'" ];
    };
  };

  systemd.services.rebind-razer-dongle = {
    description = "Rebind Razer Barracuda X USB dongle after resume";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "/bin/sh -c 'echo 1-1 > /sys/bus/usb/drivers/usb/unbind'"
        "/bin/sh -c 'echo 1-1 > /sys/bus/usb/drivers/usb/bind'" 
      ];
    };
  };
}
