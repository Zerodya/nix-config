{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd" ];
    shell = pkgs.fish;
  };
}