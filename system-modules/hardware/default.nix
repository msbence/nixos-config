{
  lib,
  config,
  ...
}:
{
  boot.swraid.mdadmConf = ''
    MAILADDR=${config.userOptions.email}
  '';

  services = {
    fwupd.enable = config.systemOptions.enableFirmwareUpdates;
    fstrim.enable = true;
    libinput.enable = config.systemOptions.enableLibInput;
    hardware.bolt.enable = config.systemOptions.enableThunderbolt;
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enableFirmwareUpdates
      [ "fwupd" ];
}
