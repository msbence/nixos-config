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
        device = "/dev/disk/by-id/nvme-CT1000T700SSD3_2411E89EFAFF";
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
                type = "swap";
                randomEncryption = true;
                priority = 100;
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
        device = "/dev/disk/by-id/nvme-KINGSTON_SKC3000S1024G_50026B73827913FF";
        content = {
          type = "gpt";
          partitions = {
            games-nvme = {
              size = "100%";
              content = {
                type = "luks";
                name = "games-nvme-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  mountpoint = "/games/nvme";
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
      disk2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-CT2000MX500SSD1_1918E2008AE3";
        content = {
          type = "gpt";
          partitions = {
            games-sata = {
              size = "100%";
              content = {
                type = "luks";
                name = "games-sata-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  mountpoint = "/games/sata";
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
      disk3 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Force_MP510_20098263000129531633";
        content = {
          type = "mdraid";
          name = "raid1";
        };
      };
      disk4 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Force_MP510_2009826300012953161F";
        content = {
          type = "mdraid";
          name = "raid1";
        };
      };
    };
    mdadm = {
      raid1 = {
        type = "mdadm";
        level = 1;
        content = {
          type = "gpt";
          partitions = {
            raid1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "raid1-encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/raid1";
                  mountOptions = [
                    "defaults"
                    "relatime"
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
