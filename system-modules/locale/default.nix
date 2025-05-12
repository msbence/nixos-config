{
  lib,
  config,
  ...
}:
{
  time.timeZone = config.systemOptions.timeZone;
  console = {
    keyMap = config.systemOptions.keyboardLayout;
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = config.systemOptions.additionalLocaleSettings;
  };
}
