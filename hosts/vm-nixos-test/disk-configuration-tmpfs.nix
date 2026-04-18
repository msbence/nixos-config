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
              size = "16G";
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
                passwordFile = "/tmp/secret.key"; # use `echo -n "password" > /tmp/secret.key`
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
