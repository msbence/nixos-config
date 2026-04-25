{
  lib,
  config,
  ...
}:
{
  time.timeZone = lib.mkDefault (
    if config.systemOptions.deviceType == "server" then "Etc/UTC" else "Europe/Vienna"
  );
  console = {
    keyMap = config.systemOptions.keyboardLayout;
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = config.systemOptions.additionalLocaleSettings;
  };
}
