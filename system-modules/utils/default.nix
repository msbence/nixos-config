{
  config,
  pkgs,
  ...
}:
{
  environment = {
    # Avoid putting too much packages here, only essential and system-level stuff should live here!
    systemPackages = with pkgs; [
      curl
      dnsutils
      ethtool
      file
      git
      gptfdisk
      htop
      nano
      pciutils
      usbutils
      unzip
      wget
      zip
    ];

    variables.EDITOR = "nano";
  };
}
