{
  lib,
  config,
  ...
}:
{
  networking = {
    networkmanager.enable = config.systemOptions.enableNetworkManager;
    resolvconf.enable = true;
    wireguard.enable = lib.mkDefault (config.systemOptions.deviceType != "server");

    hostName = "${config.systemOptions.hostname}";
    hosts = {
      "127.0.0.1" = [ "${config.systemOptions.hostname}" ];
    };
  };

  programs = {
    mtr.enable = true;
    wireshark.enable = config.systemOptions.enableWireshark;
  };

  services = {
    openssh = {
      enable = lib.mkDefault (config.systemOptions.deviceType == "server");
      settings.PermitRootLogin = lib.mkDefault "no";
    };

    gns3-server = lib.mkIf config.systemOptions.enableGns3 {
      enable = true;
      dynamips.enable = true;
      ubridge.enable = true;
      vpcs.enable = true;
    };
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enableNetworkManager [ "networkmanager" ]
    ++ lib.optionals config.systemOptions.enableWireshark [ "wireshark" ];

  environment.persistence."/persisted/system".directories =
    lib.optionals config.systemOptions.enableNetworkManager
      [ "/etc/NetworkManager/system-connections" ];
}
