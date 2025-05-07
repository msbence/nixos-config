{ lib, ... }:
with lib;
{
  services.openssh.settings.PermitRootLogin = mkForce "yes";
}
