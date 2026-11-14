{ config, pkgs, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "desktop";
  systemOptions.enableSteamOSExperience = true;
  systemOptions.windowManager = "gamescope";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;
}
