{
  lib,
  config,
  systemProperties,
  userProperties,
  ...
}:
{
  networking = {
    networkmanager.enable = config.systemOptions.enableNetworkManager;
    resolvconf.enable = true;
    wireguard.enable = config.systemOptions.enableWireguard;

    hostName = "${systemProperties.hostname}";
    hosts = {
      "127.0.0.1" = [ "${systemProperties.hostname}" ];
    };
  };

  programs = {
    mtr.enable = true;
    wireshark.enable = config.systemOptions.enableWireshark;
  };

  services = {
    openssh = {
      enable = config.systemOptions.enableSsh;
      settings.PermitRootLogin = config.systemOptions.permitSshRootLogin;
    };

    gns3-server = lib.mkIf config.systemOptions.enableGns3 {
      enable = true;
      dynamips.enable = true;
      ubridge.enable = true;
      vpcs.enable = true;
    };
  };

  users.users.${userProperties.username}.extraGroups =
    lib.optionals config.systemOptions.enableNetworkManager [ "networkmanager" ]
    ++ lib.optionals config.systemOptions.enableWireshark [ "wireshark" ];

  environment.persistence."/persisted/system".directories =
    lib.optionals config.systemOptions.enableNetworkManager
      [ "/etc/NetworkManager/system-connections" ];
}
