{
  lib,
  config,
  ...
}:
{
  options.userOptions = with lib; {
    ###> GENERAL
    username = mkOption {
      type = types.str;
      default = "raptor";
    };
    fullName = mkOption {
      type = types.str;
      default = "Bence Madarasz";
    };
    emailUser = mkOption {
      type = types.str;
      default = "raptor";
    };
    emailDomain = mkOption {
      type = types.str;
      default = "mbraptor.tech";
    };
    email = mkOption {
      type = types.str;
      readOnly = true;
      default = "${config.userOptions.emailUser}@${config.userOptions.emailDomain}"; # less food for scrapers
    };
    homeManagerStateVersion = mkOption {
      type = types.str;
    };
    ###<
  };
}
