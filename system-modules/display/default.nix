{ ... }:
{
  xdg.portal = {
    enable = false;
    config.common.default = "*";
    #extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };
}
