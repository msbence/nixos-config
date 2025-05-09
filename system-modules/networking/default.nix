{ lib, config, systemProperties, ... }:
{
  networking = {
    networkmanager.enable = true;
    resolvconf.enable = true;
    wireguard.enable = true;

    hostName = "${systemProperties.hostname}";
    hosts = {
      "127.0.0.1" = [ "${systemProperties.hostname}" ];
    };
  };

  programs = {
    mtr.enable = true;
    wireshark.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    gns3-server = {
      enable = false;
      dynamips.enable = false;
      ubridge.enable = false;
      vpcs.enable = false;
    };
  };
}
 