{ lib, systemProperties, ... }:
{
  options.systemOptions = with lib; {

    ### SECURITY

    enableAutologin = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable automatic login";
    };
    enableFingerprint = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fingerprint services";
    };
    enableTpm = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable TPM2 services";
    };
    enableGpg = mkOption {
      type = types.bool;
      default = if systemProperties.type == "server" then false else true;
      description = "Enable GPG services";
    };
    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firewall";
    };

    ####
  };
}
