{
  # Power management daemon
  services.tlp = {
      enable = true;
      settings = {
        # CPU Governor
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # Energy Performance Policy (HWP)
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        # CPU Performance limits
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 70;

        # CPU Boost (Turbo)
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;

        # Platform Profile (fan/thermal curve)
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        # Battery charge thresholds
        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 100;

        # Intel GPU runtime power management (keep off for stability)
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "on";

        # Audio power save
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # NMI watchdog
        NMI_WATCHDOG = 0;

        # Disable autosuspend
        USB_DENYLIST = "28de:1142"; # Steam Controller dongle
      };
  };
  services.power-profiles-daemon.enable = false; # Conflicts with tlp

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
      echo 0 > /proc/sys/kernel/nmi_watchdog
    '';
  };

  # Suspend-to-RAM and powersave features on laptops
  powerManagement.enable = true;

  # powertop auto tuning on startup
  #powerManagement.powertop.enable = true;
  
  # Disable Ethernet port
  networking.interfaces.enp4s0.useDHCP = false;
}