{
  themeOptions,
  ...
}:
{
  stylix = {
    enable = true;
    overlays.enable = false;

    base16Scheme = themeOptions.base16ColorScheme;
    override = themeOptions.stylixColorOverrides;

    fonts = themeOptions.fontFamilies // {
      sizes = themeOptions.fontSizing;
    };

  targets.gnome.enable = false;
  };
}
