{
  config,
  lib,
  userProperties,
  ...
}:
{
  services = {
    printing.enable = config.systemOptions.enablePrinting;
  };

  users.users.${userProperties.username}.extraGroups =
    lib.optionals config.systemOptions.enableDocker
      [ "cups" ];
}
