{ config, pkgs, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "desktop";
  systemOptions.enableSteamOSExperience = true;
  systemOptions.deviceIsSteamDeck = false;

  themeOptions.colorScheme = "blue";

  systemOptions.bootloaderType = "systemd-boot";
  #systemOptions.bootloaderTimeout = 0;
  services.openssh.enable = true;
}
