{
  themeOptions,
  ...
}:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "${themeOptions.wallpapers + "/3840x2160.png"}"
      ];

      wallpaper = [
        ",${themeOptions.wallpapers + "/3840x2160.png"}"
        "eDP-1,${themeOptions.wallpapers + "/3840x2160.png"}"
        "desc:Dell Inc. DELL U2719D GG3DR83,${themeOptions.wallpapers + "/3840x2160.png"}"
      ];
    };
  };
}
