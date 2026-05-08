{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = config.systemOptions.sopsKeyPath;
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = config.systemOptions.sopsKeyPath;
  };

  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  services = {
    fprintd = {
      enable = lib.mkOverride 100 false;
    };

    getty.autologinUser = lib.mkIf config.systemOptions.enableAutologin "${config.userOptions.username
    }";
  };

  security = {
    tpm2.enable = lib.mkDefault (config.systemOptions.deviceType != "server");
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    gnupg.agent = lib.mkIf config.systemOptions.enableGpg {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-rofi;
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
