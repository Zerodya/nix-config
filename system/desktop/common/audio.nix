{
  # Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # REAPER auto-connects to the default sink; let qpwgraph's patchbay handle routing
    extraConfig.jack."10-reaper"."jack.rules" = [{
      matches = [{ "client.name" = "REAPER"; }];
      actions.update-props."jack.self-connect-mode" = "ignore-external";
    }];
  };
  services.pulseaudio.enable = false;
}