{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation = {
    docker.enable = config.systemOptions.containerizationType == "docker";

    podman = lib.mkIf (config.systemOptions.containerizationType == "podman") {
      enable = true;
      dockerCompat = true;
    };

    libvirtd = lib.mkIf (config.systemOptions.virtualizationType == "kvm") {
      enable = true;

      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;

    vmware.host = lib.mkIf (config.systemOptions.virtualizationType == "vmware") {
      enable = true;
    };
  };

  environment.systemPackages = lib.optionals (
    config.systemOptions.virtualizationType == "kvm"
  ) [ pkgs.virt-viewer ];

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals (config.systemOptions.containerizationType == "docker") [ "docker" ]
    ++ lib.optionals (config.systemOptions.virtualizationType == "kvm") [
      "kvm"
      "libvirtd"
    ];

  preservation.preserveAt."/persisted".directories = lib.optionals (
    config.systemOptions.virtualizationType == "kvm"
  ) [ "/var/lib/libvirt" ];

  services = {
    spice-vdagentd.enable = config.systemOptions.virtualizationType == "kvm";
    spice-autorandr.enable = config.systemOptions.virtualizationType == "kvm";

    cockpit = lib.mkIf config.systemOptions.enableCockpit {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };
  };
}
