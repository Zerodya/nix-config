{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools # adb
  ];

  nixpkgs.config.android_sdk.accept_license = true;

}