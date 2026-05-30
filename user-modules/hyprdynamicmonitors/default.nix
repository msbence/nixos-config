{
  inputs,
  lib,
  config,
  systemOptions,
  ...
}:
{
  home.packages = [ inputs.hyprdynamicmonitors.packages.${systemOptions.architecture}.default ];

  home.hyprdynamicmonitors = {
    enable = true;
    installExamples = false;

    extraFiles = {
      "hyprdynamicmonitors/profiles" = ./profiles;
    };
  };

  # super-mega-hacky approach to make the main config.toml writable - but still nix-managed - for the Dynamic Profile Modes Pattern
  home.activation.setupHyprDynamicMonitors = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.home.homeDirectory}/.config/hyprdynamicmonitors
    install -m 644 -D ${./config.toml} ${config.home.homeDirectory}/.config/hyprdynamicmonitors/config.toml
  '';
}
