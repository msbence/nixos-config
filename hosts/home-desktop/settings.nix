{ config, ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = true;

  systemOptions.enableFirewall = false;
  #systemOptions.virtualizationType = "vmware";  # not surprised, broadcom doesn't think wayland needs to be supported

  systemOptions.bootloaderType = "refind";
  systemOptions.bootloaderTimeout = 4;
  services.openssh.enable = true;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;

  systemd.tmpfiles.rules = [
    # Type Path        Mode UID                            GID    Age Argument
    "d     /games/nvme 0755 ${config.userOptions.username} users  -   -"
    "d     /games/sata 0755 ${config.userOptions.username} users  -   -"
    "d     /raid1      0755 ${config.userOptions.username} users  -   -"
  ];
}
