{inputs, ...}: {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    lowLatency = {
      enable = true;
      # theoretical latency = quantum/rate (48/48000 = 1ms)
      quantum = 64; # increase if you get no sound
      rate = 48000;
    };
  };
  security.rtkit.enable = true; # make pipewire realtime-capable
}