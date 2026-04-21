{
  config,
  lib,
  ...
}:
{
  services = {
    printing.enable = config.systemOptions.enablePrinting;
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enablePrinting
      [ "cups" ];
}
