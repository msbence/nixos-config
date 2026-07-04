{
  config,
  pkgs,
  ...
}:
{
  programs.wleave = {
    enable = true;
    settings = {
      no-version-info = true;
      column-spacing = "25px";
      margin-top = "32%";
      margin-bottom = "32%";
      buttons-per-row = "1/1";
      buttons = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
          icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
          icon = "${pkgs.wleave}/share/wleave/icons/suspend.svg";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
          icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
        }
      ];
    };
    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }
      window {
        background-color: rgba(0, 0, 0, 0.6);
      }
      button {
        border-radius: 20px;
        color: #${config.lib.stylix.colors.base0D};
        background-color: #${config.lib.stylix.colors.base00};
      }
      button:focus, button:active, button:hover {
        border-radius: 20px;
        border: 2px solid #${config.lib.stylix.colors.base0D};
        background-color: #${config.lib.stylix.colors.base02};
      }
    '';
  };
}
