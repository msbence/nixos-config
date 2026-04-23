{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };

  services = {
    fprintd = lib.mkIf config.systemOptions.enableFingerprint {
      enable = true;
    };

    getty.autologinUser = lib.mkIf config.systemOptions.enableAutologin "${config.userOptions.username
    }";
  };

  security = {
    tpm2.enable = config.systemOptions.enableTpm;
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    gnupg.agent = lib.mkIf config.systemOptions.enableGpg {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  networking = {
    firewall = lib.mkIf config.systemOptions.enableFirewall {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
