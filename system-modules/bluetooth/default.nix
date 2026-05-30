{ lib, config, ... }:
{
  hardware = {
    bluetooth = lib.mkIf config.systemOptions.enableBluetooth {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

  services = {
    blueman.enable = config.systemOptions.enableBluetooth;
  };

  preservation.preserveAt."/persisted".directories =
    lib.optionals config.systemOptions.enableBluetooth
      [ "/var/lib/bluetooth" ];
}
