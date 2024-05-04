{ pkgs, lib, ... }:

{
  users.users.alpha = {
    isNormalUser = true;
    description = "alpha";
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" "adbusers" "libvirtd" ];
    shell = pkgs.fish;
  };
  users.groups = {
    users.gid = lib.mkForce 1000;
  };
}