{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      grub.enable = false;
      timeout = config.systemOptions.bootloaderTimeout;

      systemd-boot = lib.mkIf (config.systemOptions.bootloaderType == "systemd-boot") {
        enable = true;
        configurationLimit = config.systemOptions.bootloaderGenerations;
        netbootxyz.enable = lib.mkDefault true;
        memtest86.enable = lib.mkDefault true;
        edk2-uefi-shell.enable = lib.mkDefault true;
      };

      refind = lib.mkIf (config.systemOptions.bootloaderType == "refind") {
        enable = true;
        maxGenerations = config.systemOptions.bootloaderGenerations;
        theme = pkgs.mkRefindTheme {
          name = config.themeOptions.colorScheme;
          src = config.themeOptions.refindTheme;
          description = "${config.themeOptions.colorScheme} rEFInd theme";
        };
        themeName = config.systemOptions.refindTheme;
        showTools = [ ];
        defaultSelection = "NixOS";
        extraConfig = ''
          use_graphics_for osx,linux,elilo,grub,windows
          resolution max
          dont_scan_dirs EFI/netbootxyz,EFI/edk2-uefi-shell,EFI/memtest86,EFI/systemd,EFI/nixos,EFI/BOOT,efi/refind/kernels
        '';
      };
    };

    initrd = {
      systemd.enable = true;
      verbose = if config.systemOptions.enablePlymouth then false else true;
    };

    initrd.systemd.services.rollback = lib.mkIf (config.systemOptions.impermanenceType == "btrfs") {
      description = "Rollback BTRFS root subvolume";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "systemd-cryptsetup@encrypted.service"
      ];
      before = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/encrypted /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };

    kernelPackages = lib.mkIf (config.systemOptions.deviceType != "server") (
      lib.mkDefault pkgs.linuxPackages_zen
    );

    kernelParams = [
      "boot.shell_on_fail"
      "loglevel=3"
      "audit=0"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ]
    ++ lib.optionals config.systemOptions.enablePlymouth [
      "quiet"
      "splash"
      "plymouth.use-simpledrm"
      "rd.systemd.show_status=false"
    ];

    consoleLogLevel = if config.systemOptions.enablePlymouth then 0 else 3;

    plymouth = lib.mkIf config.systemOptions.enablePlymouth {
      enable = true;
      theme = config.themeOptions.colorScheme;
      themePackages = [
        config.themeOptions.plymouthThemePackage
      ];

      font = "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf";

      extraConfig = ''
        DeviceScale=${config.systemOptions.plymouthScale}
      '';
    };
  };
}
