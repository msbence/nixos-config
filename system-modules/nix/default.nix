{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  system.stateVersion = config.systemOptions.systemStateVersion;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "${config.userOptions.username}" ];
    };

    gc = lib.mkDefault {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  nixpkgs = {
    config.allowUnfree = config.systemOptions.allowUnfreePackages;

    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = config.systemOptions.allowUnfreePackages;
        };
      })
    ];
  };
}
