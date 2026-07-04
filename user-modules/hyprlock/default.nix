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
          path = "${themeOptions.wallpapers + "/3840x2160.png"}"; # a bit suboptimal, but I have no idea how to do this nicely
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.8;
        }
      ];

      shape = [
        {
          monitor = "";
          size = "760, 360";
          position = "0, 0";
          halign = "center";
          valign = "center";
          rounding = 20;
          color = "rgba(${config.lib.stylix.colors.base01}80)";
          border_size = 2;
          border_color = "rgb(${config.lib.stylix.colors.base0D})";
          shadow_passes = 2;
        }
        {
          monitor = "";
          size = "2, 260";
          position = "0, 0";
          halign = "center";
          valign = "center";
          rounding = 0;
          color = "rgba(255, 255, 255, 0.15)";
        }
      ];

      input-field = [
        {
          size = "280, 45";
          position = "190, -50";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          rounding = 12;
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          inner_color = "rgba(255, 255, 255, 0.05)";
          outer_color = "rgb(${config.lib.stylix.colors.base0D})";
          outline_thickness = 1;
          placeholder_text = "<i>Password...</i>";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 68;
          color = "rgb(${config.lib.stylix.colors.base05})";
          position = "-190, 35";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:43200000] echo "$(date +"%Y-%m-%d")"'';
          font_size = 18;
          color = "rgb(${config.lib.stylix.colors.base0D})";
          position = "-190, -35";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:43200000] echo "$(date +"%A")"'';
          font_size = 16;
          color = "rgb(${config.lib.stylix.colors.base0D})";
          position = "-190, -65";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "󰇄   ${systemOptions.hostname}<br/>   $USER";
          text_align = "left";
          font_size = 18;
          color = "rgb(${config.lib.stylix.colors.base0D})";
          position = "190, 40";
          halign = "center";
          valign = "center";
        }
      ]
      ++ lib.optionals (systemOptions.enableFingerprint) [
        {
          monitor = "";
          text = "$FPRINTPROMPT";
          text_align = "center";
          color = "rgb(${config.lib.stylix.colors.base0D})";
          font_size = 11;
          position = "190, -75";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
