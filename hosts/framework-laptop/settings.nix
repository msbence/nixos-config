{
  lib,
  ...
}:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "laptop";

  services.tlp.enable = lib.mkForce false;
}
