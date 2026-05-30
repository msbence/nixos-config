{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    printing = lib.mkIf config.systemOptions.enablePrinting {
      enable = true;
      cups-pdf.enable = true;
      drivers = with pkgs; [
        gutenprint
        unstable.mfcl8690cdwcupswrapper
      ];
    };

    avahi = lib.mkIf config.systemOptions.enablePrinting {
      enable = true;
      nssmdns4 = true;
    };
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enablePrinting
      [
        "lp"
        "lpadmin"
      ];

  environment.systemPackages = lib.optionals config.systemOptions.enablePrinting [
    pkgs.system-config-printer
    pkgs.airscan
  ];

  preservation.preserveAt."/persisted".directories =
    lib.optionals config.systemOptions.enablePrinting
      [ "/var/lib/cups" ];
}
