{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.themeOptions = with lib; {
    enableTheming = mkOption {
      type = types.bool;
      default = if config.systemOptions.deviceType == "server" then false else true;
      description = "Enable custom theming";
    };

    colorScheme = mkOption {
      type = types.enum [
        "blue"
        "brown"
      ];
      description = "The color that dominates in the theme";
      default = "blue";
    };

    base16ColorScheme = mkOption {
      type = types.str;
      description = "base16 compatible color scheme"; # https://tinted-theming.github.io/tinted-gallery
    };

    stylixColorOverrides = mkOption {
      type = types.attrs;
      description = "Color palettes to override in stylix";
      default = { };
    };

    fontFamilies = mkOption {
      type = types.attrs;
      description = "Font families to use";
      default = {
        serif = {
          package = pkgs.inter;
          name = "Inter";
        };

        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };

        monospace = {
          package = pkgs.source-code-pro;
          name = "Source Code Pro Medium";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    fontSizing = mkOption {
      type = types.attrs;
      description = "Font size to use";
      default = {
        desktop = 12;
        popups = 12;
        applications = 12;
        terminal = 12;
      };
    };

    refindTheme = mkOption {
      type = types.path;
      default = ./${config.themeOptions.colorScheme}/refind;
    };

    wallpapers = mkOption {
      type = types.path;
      default = ./${config.themeOptions.colorScheme}/wallpapers;
    };

    cursorTheme.package = mkOption {
      type = types.attrs;
      description = "Package containing the cursor theme";
    };

    cursorTheme.name = mkOption {
      type = types.str;
      description = "Name of the cursor theme";
    };

    plymouthThemePackage = mkOption {
      type = lib.types.nullOr types.attrs;
      description = "Package of the plymouth theme";
      default =
        if config.systemOptions.enablePlymouth then
          pkgs.callPackage ./${config.themeOptions.colorScheme}/plymouth/default.nix { }
        else
          null;
    };
  };
}
