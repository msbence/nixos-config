{ config, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "laptop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = false;

  systemOptions.enableFirewall = false;

  systemOptions.bootloaderType = "refind";
  systemOptions.bootloaderTimeout = 2;
  services.openssh.enable = true;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;
}
