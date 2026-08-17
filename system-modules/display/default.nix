{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.systemOptions.windowManager != "none") {
  programs.hyprland.enable = (config.systemOptions.windowManager == "hyprland");

  xdg.portal = {
    enable = true;
    config.common.default = [ "wlr" "gtk" ];
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
