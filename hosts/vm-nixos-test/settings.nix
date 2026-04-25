{ pkgs, ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";
  systemOptions.deviceIsVirtual = true;

  systemOptions.enableFirewall = false;

  services.openssh.enable = true;
  #boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
}
