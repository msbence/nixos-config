{
  themeOptions,
  ...
}:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "${themeOptions.wallpapers + "/3840x2160.png"}";
          fit_mode = "fill";
        }
        {
          monitor = "eDP-1";
          path = "${themeOptions.wallpapers + "/3840x2160.png"}";
        }
        {
          monitor = "desc:Dell Inc. DELL U2719D GG3DR83";
          path = "${themeOptions.wallpapers + "/3840x2160.png"}";
        }
      ];
    };
  };
}
