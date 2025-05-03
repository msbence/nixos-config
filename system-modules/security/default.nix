{ pkgs, userProperties, ... }:
{
  services = {
    fprintd = {
      enable = true;
    };

    getty.autologinUser = "${userProperties.username}";
  };

  security = {
    tpm2.enable = true;
    polkit.enable = true;
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
