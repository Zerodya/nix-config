{ minecraft-server, ... }:

{
  imports = [
      ./hardware-configuration.nix

      # Server
      ../../../system/server/common/default.nix
  ];

  networking.hostName = minecraft-server;

  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "NixOS Minecraft server on Tailscale!";
      max-players = 4;
      level-seed = "";
    };

    jvmOpts = "-Xmx4G -Xms4G -XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M";

    online-mode = false;
    openFirewall = true;
  };

}