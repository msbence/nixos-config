{
  config,
  pkgs,
  lib,
  systemOptions,
  userOptions,
  ...
}:
let
  hyprland-logout = pkgs.writeScriptBin "hyprland-logout" ''
    #!/bin/sh

    systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP
    steamosctl switch-to-game-mode
    sudo systemd-run --system sh -c '
      loginctl terminate-user raptor
      sleep 2
      rm -rf /tmp/.X0-lock /tmp/.X11-unix/X0 /tmp/.X1-lock /tmp/.X11-unix/X1
      rm -rf /run/user/1000/wayland-* /run/user/1000/hypr
      systemctl restart display-manager.service
    '
  '';
in
{
  programs.wleave = {
    enable = true;
    settings = {
      no-version-info = true;
      column-spacing = if (systemOptions.hasTouchscreen) then "5px" else "25px";
      row-spacing = if (systemOptions.hasTouchscreen) then "5px" else "25px";
      margin = if (systemOptions.hasTouchscreen) then "2%" else "20%";
      margin-top = if (systemOptions.hasTouchscreen) then "16%" else "32%";
      margin-bottom = if (systemOptions.hasTouchscreen) then "16%" else "32%";
      buttons-per-row = if (systemOptions.hasTouchscreen) then "1/2" else "1/1";
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
      ]
      ++ lib.optionals (systemOptions.hasTouchscreen) [
        {
          label = "osk";
          action = "pkill -SIGRTMIN wvkbd";
          text = "Show keyboard";
          keybind = "k";
          icon = ./icons/keyboard.svg;
        }
        {
          label = "apps";
          action = "walker";
          text = "Applications";
          keybind = "a";
          icon = ./icons/apps.svg;
        }
      ]
      ++ lib.optionals (systemOptions.deviceIsSteamDeck) [
        {
          label = "steamui";
          action = "${hyprland-logout}/bin/hyprland-logout";
          text = "Back to Gaming Mode";
          keybind = "g";
          icon = ./icons/steam.svg;
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
