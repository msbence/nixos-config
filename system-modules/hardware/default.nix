{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot.swraid.mdadmConf = ''
    MAILADDR=${config.userOptions.email}
  '';

  # Override mdmonitor to log to syslog instead of emailing or alerting
  systemd.services."mdmonitor".environment = {
    MDADM_MONITOR_ARGS = "--scan --syslog";
  };

  services = {
    fwupd.enable = config.systemOptions.enableFirmwareUpdates;
    fstrim.enable = true;
    libinput.enable = config.systemOptions.enableLibInput;
    hardware.bolt.enable = config.systemOptions.enableThunderbolt;
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enableFirmwareUpdates
      [ "fwupd" ];

  environment.systemPackages = lib.optionals (config.systemOptions.hasRgbLeds) [
    pkgs.unstable.openrgb
    pkgs.i2c-tools
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.hardware.openrgb.enable = config.systemOptions.hasRgbLeds;

  preservation.preserveAt."/persisted".directories = lib.optionals config.systemOptions.hasRgbLeds [
    "/var/lib/OpenRGB"
  ];
}
