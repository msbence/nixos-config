{
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=75%"
          "defaults"
          "mode=755"
        ];
      };
    };
    disk = {
      disk0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_500GB_S5GYNG0NB10778Z";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "luks";
                name = "swap-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "swap";
                };
              };
            };
            main = {
              size = "100%";
              content = {
                type = "luks";
                name = "main-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=home"
                        "compress=zstd"
                        "relatime"
                        "ssd"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                        "ssd"
                      ];
                    };
                    "/persisted" = {
                      mountpoint = "/persisted";
                      mountOptions = [
                        "subvol=persisted"
                        "compress=zstd"
                        "relatime"
                        "ssd"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HALU-000L1_S4YCNF0NA63877";
        content = {
          type = "gpt";
          partitions = {
            games-nvme = {
              size = "100%";
              content = {
                type = "luks";
                name = "secondary-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  mountpoint = "/secondary-disk";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
