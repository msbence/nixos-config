{
  config,
  pkgs,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      nano
      git
      curl
      wget
      htop
      pciutils
      usbutils
      unzip
      zip
    ];

    variables.EDITOR = "nano";
  };
}
