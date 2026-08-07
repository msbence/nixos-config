{ config, ... }:
{
  systemOptions.systemStateVersion = "26.05";
  userOptions.homeManagerStateVersion = "26.05";

  systemOptions.deviceType = "laptop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = false;

  systemOptions.enableFirewall = true;
  #systemOptions.virtualizationType = "vmware";  # not surprised, broadcom doesn't think wayland needs to be supported

  systemOptions.bootloaderType = "refind";
  systemOptions.bootloaderTimeout = 4;
  services.openssh.enable = false;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;
}
