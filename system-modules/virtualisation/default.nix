{ pkgs, ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true;
        runAsRoot = true;

        ovmf = {
          enable = true;
          packages = with pkgs; [ OVMFFull.fd ];
        };
      };
    };
  };

  services = {
    cockpit = {
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
