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
      enable = config.systemOptions.enableFingerprint;
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
      extraCommands = ''
        iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -I INPUT -p udp -m udp --match multiport --dports 1990,2021 -j ACCEPT
      '';
    };
  };
}
