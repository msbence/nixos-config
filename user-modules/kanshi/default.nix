{ ... }:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile.name = "HOME";
        profile.outputs = [
          {
            criteria = "Philips Consumer Electronics Company PHL 273V7 0x00000DDD";
            mode = "1920x1080@60.000";
            position = "0,0";
            transform = "normal";
          }
          {
            criteria = "LG Electronics LG ULTRAGEAR+ 308NTBK9U373";
            mode = "3840x2160@60.000";
            position = "1920,0";
            transform = "normal";
            scale = 1.6;
          }
          {
            criteria = "Philips Consumer Electronics Company PHL 273V7 0x00006CA1";
            mode = "1920x1080@60.000";
            position = "4320,0";
            transform = "normal";
          }
        ];
        profile.exec = [
          "echo HOME > $HOME/.current_screenlayout"
        ];
      }
    ];
  };
}
