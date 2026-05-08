{ config, ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";
  systemOptions.deviceIsVirtual = false;

  systemOptions.enableFirewall = false;

  services.openssh.enable = true;
  #boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  userOptions.themeColor = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;
}
