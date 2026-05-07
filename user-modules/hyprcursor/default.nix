{ inputs, systemOptions, ... }:
{
  home.pointerCursor = {
    hyprcursor.enable = true;
    package = inputs.future-hyprcursor.packages.${systemOptions.architecture}.default;
    name = "future-cyan-hyprcursor";
    size = 42;
    gtk.enable = true;
    x11.enable = true;
  };
}
