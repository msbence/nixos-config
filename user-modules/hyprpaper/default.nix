{ ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "${./wallpapers/3840x2160.png}"
      ];

      wallpaper = [
        ",${./wallpapers/3840x2160.png}"
        "eDP-1,${./wallpapers/3840x2160.png}"
        "desc:Dell Inc. DELL U2719D GG3DR83,${./wallpapers/3840x2160.png}"
      ];
    };
  };
}
