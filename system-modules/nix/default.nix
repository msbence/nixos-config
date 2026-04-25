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
          system = prev.system;
          config.allowUnfree = config.systemOptions.allowUnfreePackages;
        };
      })
    ];
  };
}
