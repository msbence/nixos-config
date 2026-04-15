{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.systemOptions.windowManager != "none") {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  environment = {
    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };

  programs.dconf.enable = true;
}
