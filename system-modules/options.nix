{ lib, systemProperties, ... }:
{
  options = with lib; {
    enableAutologin = mkOption {
      type = types.enum [
        "yes"
        "no"
      ];
      default = if systemProperties.type == "server" then "no" else "yes";
      description = "Enable root login";
    };
  };
}
