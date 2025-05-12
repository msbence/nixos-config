{
  lib,
  config,
  userProperties,
  ...
}:
{
  services = {
    fwupd.enable = config.systemOptions.enableFirmwareUpdates;
    fstrim.enable = true;
    libinput.enable = config.systemOptions.enableLibInput;
    hardware.bolt.enable = config.systemOptions.enableThunderbolt;
  };

  users.users.${userProperties.username}.extraGroups =
    lib.optionals config.systemOptions.enableFirmwareUpdates
      [ "fwupd" ];
}
