{
  lib,
  config,
  ...
}:
let
  vpnEncConfigDir = ../../secrets/vpn;
  vpnEncConfigFiles = lib.filterAttrs (vpnName: type: lib.hasSuffix ".nmconnection" vpnName) (builtins.readDir vpnEncConfigDir);

  vpnSecrets = lib.mapAttrs' (vpnName: type: {
    name = "vpn/${vpnName}";
    value = {
      sopsFile = "${vpnEncConfigDir}/${vpnName}";
      format = "binary";
      path = "/etc/NetworkManager/system-connections/${vpnName}";
      mode = "0600";
    };
  }) vpnEncConfigFiles;
in
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

  sops.secrets = lib.mkIf config.systemOptions.enableNetworkManager vpnSecrets;

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

  preservation.preserveAt."/persisted".directories =
    lib.optionals config.systemOptions.enableNetworkManager
      [ "/etc/NetworkManager/system-connections" ];
}
