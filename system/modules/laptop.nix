{
  # Power management daemon
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       # Save long term battery health
       #START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       #STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
  };
  services.power-profiles-daemon.enable = false; # Disable GNOME power profiles which conflicts with tlp

  # Temperature management daemon
  services.thermald.enable = true;

  # DBus service that provides power management support to applications
  services.upower.enable = true;
  
  # Custom powersave script
  systemd.services.powersave = {
    enable = true;

    description = "Apply power saving tweaks";
    wantedBy = ["multi-user.target"];

    script = ''
      echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
      echo 1 > /sys/module/snd_hda_intel/parameters/power_save
      #echo 0 > /proc/sys/kernel/nmi_watchdog
  
      for i in /sys/bus/pci/devices/*; do
        echo auto > "$i/power/control"
      done
  
      echo auto > /sys/bus/i2c/devices/i2c-0/device/power/control
      echo auto > /sys/bus/i2c/devices/i2c-2/device/power/control
      echo auto > /sys/bus/i2c/devices/i2c-5/device/power/control
    '';
  };

  # Suspend-to-RAM and powersave features on laptops
  powerManagement.enable = true;
  # powertop auto tuning on startup
  powerManagement.powertop.enable = true;
  
  # Disable Ethernet port
  networking.interfaces.enp4s0.useDHCP = false;
}