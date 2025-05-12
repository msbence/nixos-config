{
  config,
  lib,
  ...
}:
{
  services = {
    upower.enable = true;
    tlp = {
      enable = config.systemOptions.enablePowerManagement;
      settings = config.systemOptions.powerManagementProfile;
    };
  };
}
