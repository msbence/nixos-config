{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
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
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
              };
            };
            encrypted = {
              size = "100%";
              content = {
                type = "luks";
                name = "encrypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/luks.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=root"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=home"
                        "compress=zstd"
                        "relatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persisted" = {
                      mountpoint = "/persisted";
                      mountOptions = [
                        "subvol=persisted"
                        "compress=zstd"
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
    };
  };
}
