{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 270;
        command = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 0.2";
        resumeCommand = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1";
      }
      {
        timeout = 300;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
    ];
    events = {
      before-sleep = "dms ipc lock lock";
      after-resume = "niri msg action power-on-monitors";
      lock = "dms ipc lock lock";
    };
};
}