{ systemProperties, ... }:
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
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };
}
