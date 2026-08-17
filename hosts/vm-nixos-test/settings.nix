{ ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";
  systemOptions.deviceIsVirtual = true;

  services.openssh.enable = true;
  systemOptions.enableFirewall = false;
}
