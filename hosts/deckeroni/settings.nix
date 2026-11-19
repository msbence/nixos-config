{ config, pkgs, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "handheld";
  systemOptions.deviceIsSteamDeck = true;

  systemOptions.bootloaderType = "systemd-boot";
  systemOptions.bootloaderTimeout = 2;
  services.openssh.enable = true;

  themeOptions.colorScheme = "blue";

#  systemOptions.virtualizationType = "vmware";
}
