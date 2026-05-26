{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "network"
        ];

        "hyprland/workspaces" = {
          all-outputs = false;
        };
      };

      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 34;
        modules-left = [
          "memory"
        ];
        modules-center = [
          "hyprland/language"
        ];
        modules-right = [
          "tray"
        ];

        "hyprland/language" = {
          "format-en" = "EN";
          "format-hu" = "HU";
        };
      };
    };

    style = builtins.readFile ./style.css; # not using a path literal here, as stylix wants to do stuff
  };

  stylix.targets.waybar.fonts.override.sizes.desktop = 11;
  stylix.targets.waybar.addCss = false;
}
