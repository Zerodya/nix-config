{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
  users.groups = {
    #users.gid = lib.mkForce 1000;
  };
}