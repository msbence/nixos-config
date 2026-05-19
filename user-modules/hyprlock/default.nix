{
  lib,
  config,
  systemOptions,
  themeOptions,
  ...
}:
{
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = lib.mkDefault 2;
        hide_cursor = true;
      };

      auth = {
        pam.enabled = true;
        fingerprint.enabled = lib.mkDefault systemOptions.enableFingerprint;
      };

      background = [
        {
          path = "${themeOptions.wallpapers + "/3840x2160.png"}";
        }
      ];

      input-field = [
        {
          size = "300, 50";
          position = "0, 60";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(${config.lib.stylix.colors.base0D})";
          inner_color = "rgb(${config.lib.stylix.colors.base01})";
          outer_color = "rgb(${config.lib.stylix.colors.base0D})";
          outline_thickness = 2;
          placeholder_text = "Enter password";
          shadow_passes = 2;
          halign = "center";
          valign = "bottom";
        }
      ];

      label =
        [ ]
        ++ lib.optionals (systemOptions.enableFingerprint) [
          {
            monitor = "";
            text = "$FPRINTPROMPT";
            text_align = "center";
            color = "rgb(${config.lib.stylix.colors.base0D})";
            font_size = "10";
            position = "0, 10";
            halign = "center";
            valign = "bottom";
          }
        ];
    };
  };
}
