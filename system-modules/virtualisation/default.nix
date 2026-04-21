{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation = {
    docker.enable = config.systemOptions.enableDocker;

    libvirtd = lib.mkIf config.systemOptions.enableQemu {
      enable = true;

      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
      };
    };
  };

  users.users.${config.userOptions.username}.extraGroups =
    lib.optionals config.systemOptions.enableDocker [ "docker" ]
    ++ lib.optionals config.systemOptions.enableQemu [
      "kvm"
      "libvirtd"
    ];

  services = {
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
