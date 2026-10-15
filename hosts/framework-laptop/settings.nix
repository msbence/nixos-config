{
  lib,
  pkgs,
  ...
}:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "laptop";

  services.tlp.enable = lib.mkForce false;

  services.udev.packages = [
    pkgs.teensy-udev-rules
  ];
}
