{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = builtins.fromJSON (builtins.readFile ./settings.json);

    style = builtins.readFile ./style.css; # not using a path literal here, as stylix wants to do stuff
  };

  stylix.targets.waybar.fonts.override.sizes.desktop = 11;
  stylix.targets.waybar.addCss = true;
}
