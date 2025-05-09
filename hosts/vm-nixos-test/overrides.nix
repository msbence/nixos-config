{ lib, ... }:
with lib;
{
  services.fprintd.enable = mkForce true;
  networking.firewall.enable = mkForce false;
}
