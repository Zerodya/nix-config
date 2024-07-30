# Real-time audio for Pipewire and Pulseaudio

# Theoretical latency is quantum/rate (48/48000 = 1ms)
# (increase quantum if you get crackles or no sound)

{
  services.pipewire.extraConfig = {
    pipewire."92-low-latency".context = {
      properties.default.clock = {
        
        rate = 48000;
        quantum = 48;
        min-quantum = 48;
        max-quantum = 48;
      };
    };

    pipewire-pulse."92-low-latency".context = {
      modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "48/48000";
            pulse.default.req = "48/48000";
            pulse.max.req = "48/48000";
            pulse.min.quantum = "48/48000";
            pulse.max.quantum = "48/48000";
          };
        }
      ];
      stream.properties = {
        node.latency = "48/48000";
        resample.quality = 1;
      };
    };

  };

  security.rtkit.enable = true; # make pipewire realtime-capable

}