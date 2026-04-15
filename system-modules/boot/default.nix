{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
      systemd-boot.netbootxyz.enable = config.systemOptions.enableNetbootXyz;
    };

    initrd = {
      systemd.enable = true;
      verbose = if config.systemOptions.enablePlymouth then false else true;
    };

    # initrd.systemd.services.rollback = {
    #   description = "Rollback BTRFS root subvolume";
    #   wantedBy = [
    #     "initrd.target"
    #   ];
    #   after = [
    #     "systemd-cryptsetup@encrypted.service"
    #   ];
    #   before = [
    #     "sysroot.mount"
    #   ];
    #   unitConfig.DefaultDependencies = "no";
    #   serviceConfig.Type = "oneshot";
    #   script = ''
    #     mkdir /btrfs_tmp
    #     mount /dev/mapper/encrypted /btrfs_tmp
    #     if [[ -e /btrfs_tmp/root ]]; then
    #         mkdir -p /btrfs_tmp/old_roots
    #         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
    #         mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    #     fi

    #     delete_subvolume_recursively() {
    #         IFS=$'\n'
    #         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #             delete_subvolume_recursively "/btrfs_tmp/$i"
    #         done
    #         btrfs subvolume delete "$1"
    #     }

    #     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #         delete_subvolume_recursively "$i"
    #     done

    #     btrfs subvolume create /btrfs_tmp/root
    #     umount /btrfs_tmp
    #   '';
    # };

    kernelParams =
      [
        "boot.shell_on_fail"
        "loglevel=3"
        "audit=0"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ]
      ++ lib.optionals config.systemOptions.enablePlymouth [
        #"quiet"
        #"splash"
        #"plymouth.use-simpledrm"
        #"rd.systemd.show_status=false"
      ];

    consoleLogLevel = if config.systemOptions.enablePlymouth then 0 else 3;

    plymouth = lib.mkIf config.systemOptions.enablePlymouth {
      enable = false;
      theme = config.systemOptions.plymouthTheme;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ config.systemOptions.plymouthTheme ]; })
      ];

      extraConfig = ''
        DeviceScale=${config.systemOptions.plymouthScale}
        ShowDelay=0
      '';
    };
  };
}
