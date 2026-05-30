{ lib, config, ... }:
lib.mkIf (config.systemOptions.impermanenceType != "none") {
  fileSystems."/persisted".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  preservation.enable = true;
  preservation.preserveAt."/persisted" = {
    commonMountOptions = [
      "x-gvfs-hide"
      "x-gdu.hide"
    ];

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/sops-nix"
    ];

    files = [
      {
        file = "/etc/machine-id";
        inInitrd = true;
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        how = "symlink";
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        how = "symlink";
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        how = "symlink";
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        how = "symlink";
      }
      {
        file = "/etc/ssh/ssh_known_hosts";
        how = "symlink";
      }
    ];
  };

  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
}
