{
  themeOptions,
  ...
}:
{
  home.pointerCursor = {
    enable = true;
    hyprcursor.enable = true;
    package = themeOptions.cursorTheme.package;
    name = themeOptions.cursorTheme.name;
    size = 42;
    gtk.enable = true;
    x11.enable = true;
  };
}
