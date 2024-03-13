{ pkgs, lib, ... }:

{
  users.users.alpha = {
    isNormalUser = true;
    description = "alpha";
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };
  users.groups = {
    users.gid = lib.mkForce 1000;
  };
}