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
        device = "/dev/disk/by-id/nvme-KINGSTON_OM3SGP4512K2-A00_50026B7283BD25F6";
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
              };
            };
            main = {
              size = "100%";
              content = {
                type = "luks";
                name = "main-encrypted";
                settings.allowDiscards = true;
		settings.crypttabExtraOpts = [ "fido2-device=auto" "tpm2-device=auto" ];
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
    };
  };
}
