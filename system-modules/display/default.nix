{ ... }:
{
  xdg.portal = {
    enable = false;
    config.common.default = "*";
    #extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  environment = {
    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };

  programs.dconf.enable = true;
}
