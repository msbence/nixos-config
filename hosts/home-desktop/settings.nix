{
  config,
  pkgs,
  ...
}:
let
  set-rgb = pkgs.writeScriptBin "set-rgb" ''
    #!/bin/sh

    COLOR="E06501"

    sleep 2
    
    ${pkgs.unstable.openrgb}/bin/openrgb --noautoconnect --device "TUF GAMING X670E-PLUS" --zone 1 --size 36 --zone 2 --size 12 --zone 1 --size 24 --mode static --color $COLOR \
    --device "Roccat Kone" --mode direct --color $COLOR \
    --device "RX 7900 XT" --mode static --color $COLOR \
    --device "Kingston Fury DDR5 DRAM" --mode static --color $COLOR
  '';
in
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";
  systemOptions.deviceIsVirtual = false;
  systemOptions.hasRgbLeds = true;

  systemOptions.enableFirewall = false;
  #systemOptions.virtualizationType = "vmware";  # not surprised, broadcom doesn't think wayland needs to be supported

  systemOptions.bootloaderType = "refind";
  systemOptions.bootloaderTimeout = 4;
  services.openssh.enable = true;

  themeOptions.colorScheme = "brown";

  home-manager.users.${config.userOptions.username}.programs.git.signing.signByDefault = false;

  systemd.tmpfiles.rules = [
    # Type Path        Mode UID                            GID    Age Argument
    "d     /games/nvme 0755 ${config.userOptions.username} users  -   -"
    "d     /games/sata 0755 ${config.userOptions.username} users  -   -"
    "d     /raid1      0755 ${config.userOptions.username} users  -   -"
  ];

  ###

  environment.systemPackages = [ pkgs.unstable.headsetcontrol ];
  services.udev.packages = [ pkgs.unstable.headsetcontrol ]; # For udev rules

  systemd.services.set-rgb = {
    enable = true;
    description = "set-rgb";
    serviceConfig = {
      ExecStart = "${set-rgb}/bin/set-rgb";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
