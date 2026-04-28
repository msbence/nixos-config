{ inputs, systemOptions, ... }:
{
  home.packages = [ inputs.hyprdynamicmonitors.packages.${systemOptions.architecture}.default ];

  home.hyprdynamicmonitors = {
    enable = true;
    configFile = ./config.toml;

    extraFiles = {
      "hyprdynamicmonitors/profiles" = ./profiles;
    };
  };
}
