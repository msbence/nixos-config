{ config, ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "laptop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = false;

  systemOptions.enableFirewall = false;
  #systemOptions.virtualizationType = "vmware";  # not surprised, broadcom doesn't think wayland needs to be supported

  systemOptions.bootloaderType = "systemd-boot";
  systemOptions.bootloaderTimeout = 4;
  services.openssh.enable = true;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;
}
