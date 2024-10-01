# Real-time audio for Pipewire and Pulseaudio

# Theoretical latency is quantum/rate (48/48000 = 1ms)
# (increase quantum if you get crackles or no sound)

{
  services.pipewire.extraConfig = {
    pipewire."92-low-latency".context = {
      properties.default.clock = {
        
        rate = 48000;
        quantum = 64;
        min-quantum = 64;
        max-quantum = 64;
      };
    };

    pipewire-pulse."92-low-latency".context = {
      modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "64/48000";
            pulse.default.req = "64/48000";
            pulse.max.req = "64/48000";
            pulse.min.quantum = "64/48000";
            pulse.max.quantum = "64/48000";
          };
        }
      ];
      stream.properties = {
        node.latency = "64/48000";
        resample.quality = 1;
      };
    };

  };

  security.rtkit.enable = true; # make pipewire realtime-capable

}